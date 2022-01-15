//
//  AppDelegate.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import AuthenticationServices
import UIKit

import Firebase
import FirebaseMessaging
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isLogin = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: "d51e83bca123750446afc70ab65225b9")
        
        let accessToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken)
        
        if accessToken != nil {
            if UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.isAppleLogin) {
                // 애플 로그인으로 연동되어 있을 때, -> 애플 ID와의 연동상태 확인 로직
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "") { credentialState, error in
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

        // 앱 실행 중 애플 ID 강제로 연결 취소 시
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { Notification in
            print("Revoked Notification")
            self.isLogin = false
        }
        
        // Firebase 초기화 세팅.
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        // 푸시알림 권한 설정.
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        
        // 푸시 알림에 앱 등록.
        application.registerForRemoteNotifications()
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
    
    // MARK: - APNs
    
    /// APN 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler([.sound, .banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler(.noData)
    }
}

extension AppDelegate: MessagingDelegate {
    /// 현재 등록 토큰 가져오기.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        // TODO: - 디바이스 토큰을 보내는 서버통신 구현
        
        sendDeviceTokenWithAPI(fcmToken: fcmToken ?? "")
    }
}

extension AppDelegate {
    private func sendDeviceTokenWithAPI(fcmToken: String) {
        
    }
}
