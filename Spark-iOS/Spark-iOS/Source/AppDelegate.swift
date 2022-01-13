//
//  AppDelegate.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import AuthenticationServices
import UIKit

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
                appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "") { (credentialState, error) in
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
                    UserApi.shared.accessTokenInfo { (_, error) in
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
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (Notification) in
            print("Revoked Notification")
            self.isLogin = false
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

