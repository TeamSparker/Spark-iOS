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
//        let rootViewController = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar)
        let rootViewController = UIStoryboard(name: Const.Storyboard.Name.goalWriting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.goalWriting)
        window?.rootViewController = rootViewController
        
        // 코드베이스로 테스트할 때 다음과 같이 사용 가능합니다.
        // window?.rootViewController = MainVC()
        
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
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

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

