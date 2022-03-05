//
//  MainTBC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit
import JJFloatingActionButton

class MainTBC: UITabBarController {

    private let floatingButton = JJFloatingActionButton()
    private let tapGestrueRecognizer = UITapGestureRecognizer()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        setGestureRecognizer()
        setAddTarget()
        setFloatingButton()
        setNotification()
        
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
        
        let homeNVC = UINavigationController(rootViewController: homeVC)
        homeNVC.isNavigationBarHidden = true
        
        let storageNVC = UINavigationController(rootViewController: storageVC)
        storageNVC.isNavigationBarHidden = true
        
        setViewControllers([feedVC, homeNVC, storageNVC], animated: false)
        
        tabBar.tintColor = .sparkDarkPinkred
        tabBar.itemPositioning = .centered
        selectedIndex = 1
        
        let appearance = UITabBarAppearance()
        // set tabbar opacity
        appearance.configureWithOpaqueBackground()
        // remove tabbar border line
        appearance.shadowColor = UIColor.clear
        // set tabbar background color
        appearance.backgroundColor = .white

        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
                // set tabbar opacity
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
    
    private func setGestureRecognizer() {
        tapGestrueRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestrueRecognizer)
    }
    
    private func setAddTarget() {
        floatingButton.addTarget(self, action: #selector(setButtonColor), for: .touchUpInside)
        tapGestrueRecognizer.addTarget(self, action: #selector(setButtonColor))
    }
    
    private func setFloatingButton() {
        // set floatingButton
        // buttonImage 와 itemAnimationConfiguration 은 default.
        floatingButton.buttonColor = .sparkDarkPinkred
        floatingButton.buttonImageColor = .sparkWhite
        floatingButton.layer.shadowColor = UIColor.sparkDarkPinkred.cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        floatingButton.layer.shadowOpacity = Float(0.3)
        floatingButton.layer.shadowRadius = CGFloat(10)
        
        // set floatingButton items
        floatingButton.addItem(title: "코드로 참여", image: UIImage(named: "icCode")) { _ in
            self.presentToCodeJoinVC()
        }
        
        floatingButton.addItem(title: "방 만들기", image: UIImage(named: "icRoomWhite")) { _ in
            self.presentToWaitingVC()
        }
        
        // 아이템 버튼 컬러 변경. defualt 는 white 임.
        floatingButton.configureDefaultItem { item in
            item.buttonColor = .sparkDarkPinkred
            item.layer.shadowColor = .none
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setAppearFloatingButtonLayout), name: .appearFloatingButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDisappearFloatingButton), name: .disappearFloatingButton, object: nil)
    }
    
    private func presentToCodeJoinVC() {
        let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.codeJoin, bundle: nil)

        guard let nextVC = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.codeJoin) as? CodeJoinVC else {return}

        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true)
    }
    
    private func presentToWaitingVC() {
        guard let rootVC = UIStoryboard(name: Const.Storyboard.Name.createRoom, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.createRoom) as? CreateRoomVC else { return }
        let nextVC = UINavigationController(rootViewController: rootVC)
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
    
    // MARK: - @objc
    
    @objc
    private func setAppearFloatingButtonLayout() {
        view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(72)
        }
    }
    
    @objc
    private func setDisappearFloatingButton() {
        floatingButton.removeFromSuperview()
    }
    
    @objc
    private func setButtonColor() {
        if floatingButton.buttonState.rawValue == 2 {
            floatingButton.buttonColor = .sparkWhite
            floatingButton.buttonImageColor = .sparkDarkPinkred
        } else {
            floatingButton.buttonColor = .sparkDarkPinkred
            floatingButton.buttonImageColor = .sparkWhite
        }
    }
    
    // TODO: - 화면전환
    
    @objc
    private func presentToProfileVC() {
        
    }
    
    @objc
    private func presentToAertVC() {
        
    }
}
