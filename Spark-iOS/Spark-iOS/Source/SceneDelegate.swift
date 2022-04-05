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
        guard let start = UserDefaults.standard.object(forKey: Const.UserDefaultsKey.sceneDidEnterBackground) as? Date else { return }
        let interval = Int(Date().timeIntervalSince(start))
        NotificationCenter.default.post(name: NSNotification.Name(Const.UserDefaultsKey.sceneWillEnterForeground), object: nil, userInfo: ["time": interval])
    }

    // Background에 들어갈때
    // sceneDidEnterBackground라는 키워드의 노티 전달하며
    // sceneDidEnterBackground라는 키워드로 값 저장
    func sceneDidEnterBackground(_ scene: UIScene) {
        UserDefaults.standard.setValue(Date(), forKey: Const.UserDefaultsKey.sceneDidEnterBackground)
    }
}
