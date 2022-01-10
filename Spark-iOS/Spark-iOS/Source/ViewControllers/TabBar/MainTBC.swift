//
//  MainTBC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

class MainTBC: UITabBarController {

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
}

// MARK: - Methods

extension MainTBC {
    private func setTabBar() {
        guard let feedVC = UIStoryboard(name: Const.Storyboard.Name.feed, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.feed) as? FeedVC,
              let homeVC = UIStoryboard(name: Const.Storyboard.Name.home, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.home) as? HomeVC,
              let storageVC = UIStoryboard(name: Const.Storyboard.Name.storage, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.storage) as? StorageVC else { return }
        
        feedVC.tabBarItem = UITabBarItem(title: "피드", image: UIImage(named: "icFeedInactive"), selectedImage: UIImage(named: "icFeedActive"))
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "icHomeInactive"), selectedImage: UIImage(named: "icHomeActive"))
        storageVC.tabBarItem = UITabBarItem(title: "보관함", image: UIImage(named: "icMyboxInactive"), selectedImage: UIImage(named: "icMyboxActive"))
    
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.caption], for: .normal)
        
        setViewControllers([feedVC, homeVC, storageVC], animated: false)
        
        tabBar.tintColor = .sparkDarkPinkred
        tabBar.itemPositioning = .centered
        selectedIndex = 1
    }
}
