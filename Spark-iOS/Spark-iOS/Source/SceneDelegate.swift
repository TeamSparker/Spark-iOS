//
//  SceneDelegate.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import UIKit

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let rootViewController = UIStoryboard(name: Const.Storyboard.Name.splash, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.splash)
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
        // 앱 종료 상태에서 푸시알림을 통해 앱에 접속하는 경우
        if let notification = connectionOptions.notificationResponse {
            let content = notification.notification.request.content
            let userInfo = content.userInfo
            guard let recordId: String = userInfo["recordId"] as? String,
                  let roomId: String = userInfo["roomId"] as? String else { return }
            
            let info: [String: Any] = ["recordID": recordId, "roomID": roomId]
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                NotificationCenter.default.post(name: .pushNotificationTapped, object: nil, userInfo: info)
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    // Foreground에 들어올 때
    // sceneDidEnterBackground라는 키워드로 저장해둔 값을 sceneWillEnterForeground라는 키워드 노티의 userInfo로 전달
    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let start = UserDefaultsManager.sceneDidEnterBackground else { return }
        let interval = Int(Date().timeIntervalSince(start))
        NotificationCenter.default.post(name: .sceneWillEnterForeground, object: nil, userInfo: ["time": interval])
    }

    // Background에 들어갈때
    // sceneDidEnterBackground라는 키워드의 노티 전달하며
    // sceneDidEnterBackground라는 키워드로 값 저장
    func sceneDidEnterBackground(_ scene: UIScene) {
        UserDefaultsManager.sceneDidEnterBackground = Date()
    }
}
