//
//  AppDelegate.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import AuthenticationServices
import UIKit
import UserNotifications

import Firebase
import FirebaseMessaging
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

@frozen
enum ThreadID: String {
    case spark
    case certification
    case remind
    case roomStart
    case consider
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isLogin = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let kakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "KakaoNativeAppKey") as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        
        let accessToken = UserDefaultsManager.accessToken
        
        if accessToken != nil {
            if UserDefaultsManager.isAppleLogin {
                // 애플 로그인으로 연동되어 있을 때, -> 애플 ID와의 연동상태 확인 로직
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                appleIDProvider.getCredentialState(forUserID: UserDefaultsManager.userID ?? "") { credentialState, _ in
                    switch credentialState {
                    case .authorized:
                        print("해당 ID는 연동되어있습니다.")
                        self.isLogin = true
                    case .revoked:
                        print("해당 ID는 연동되어있지않습니다.")
                        self.isLogin = false
                    case .notFound:
                        print("해당 ID를 찾을 수 없습니다.")
                        self.isLogin = false
                    default:
                        break
                    }
                }
            } else {
                if AuthApi.hasToken() {
                    UserApi.shared.accessTokenInfo { _, error in
                        if let error = error {
                            if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                                self.isLogin = false
                            }
                        } else {
                            // 토큰 유효성 확인한 경우.
                            self.isLogin = true
                        }
                    }
                } else {
                    // 유효한 토큰이 없는 경우.
                    self.isLogin = false
                }
            }
        } else {
            // access token 이 없는 경우.
            self.isLogin = false
        }

        // FIXME: 앱 실행 중 애플 ID 강제로 연결 취소 시
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { _ in
            print("Revoked Notification")
            self.isLogin = false
        }
        
        // Firebase 초기화 세팅.
        FirebaseApp.configure()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        // FCM 다시 사용 설정
        Messaging.messaging().isAutoInitEnabled = true
        
        // 푸시 알림 권한 설정 및 푸시 알림에 앱 등록
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        
        // device token 요청.
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        /// 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
    
    // MARK: - APNs
    
    /// APN 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// 메시지 수신
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler([.sound, .banner, .list])
    }
    
    /// background에서 푸시알림 받은 경우 또는 푸시알림 누른 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        let notificationThreadID = response.notification.request.content.threadIdentifier
        guard let threadID = ThreadID(rawValue: notificationThreadID),
              let recordId: String = userInfo["recordId"] as? String,
              let roomId: String = userInfo["roomId"] as? String else { return }

        let applicationState = UIApplication.shared.applicationState
        let info: [String: Any] = ["recordID": recordId, "roomID": roomId]

        if applicationState == .active || applicationState == .inactive {
            guard let mainTBC = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar) as? MainTBC else { return }
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let window = windowScene.windows.first  else { return }
            window.rootViewController = mainTBC
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
            
            if recordId.isEmpty {
                guard let habitRoomVC = UIStoryboard(name: Const.Storyboard.Name.habitRoom, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.habitRoom) as? HabitRoomVC else { return }
                habitRoomVC.roomID = Int(roomId)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    let topVC = UIApplication.getMostTopViewController()
                    topVC?.navigationController?.pushViewController(habitRoomVC, animated: true)
                }
            } else {
                NotificationCenter.default.post(name: .pushNotificationTapped, object: nil, userInfo: info)
            }
        }
        
        switch threadID {
        case .spark:
            Analytics.logEvent(Tracking.Notification.spark, parameters: nil)
        case .certification:
            Analytics.logEvent(Tracking.Notification.certification, parameters: nil)
        case .remind:
            Analytics.logEvent(Tracking.Notification.remind, parameters: nil)
        case .roomStart:
            Analytics.logEvent(Tracking.Notification.roomstart, parameters: nil)
        case .consider:
            Analytics.logEvent(Tracking.Notification.consider, parameters: nil)
        }
        
        completionHandler()
    }
    
    // 백그라운드에서 자동 푸시 알림 처리
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    /// 현재 등록 토큰 가져오기.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        UserDefaultsManager.fcmToken = fcmToken
    }
}
