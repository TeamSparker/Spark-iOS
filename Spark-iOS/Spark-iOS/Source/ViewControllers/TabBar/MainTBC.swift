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
        
        feedVC.tabBarItem = UITabBarItem(title: "피드", image: UIImage(), selectedImage: UIImage())
        
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(), selectedImage: UIImage())
        storageVC.tabBarItem = UITabBarItem(title: "보관함", image: UIImage(), selectedImage: UIImage())
    
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        
        setViewControllers([feedVC, homeVC, storageVC], animated: false)
        
        tabBar.tintColor = .sparkDarkPinkred
        tabBar.itemPositioning = .centered
        selectedIndex = 1
    }
}
