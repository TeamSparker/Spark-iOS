//
//  SparkTabBarController.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/14.
//

import UIKit

import JJFloatingActionButton

class SparkTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let bottomSafeArea: CGFloat = 34.0
    private let tabBarHeight: CGFloat = 54.0
    
    public let sparkTabBar = SparkTabBar()
    
    override var selectedIndex: Int {
        didSet {
            self.sparkTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }
    
    override var selectedViewController: UIViewController? {
        didSet {
            self.sparkTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setTabBar()
    }
}

// MARK: - Extension

extension SparkTabBarController {
    
    /// Set UI.
    private func setUI() {
        self.tabBar.isHidden = true
    }
    
    /// Set tab bar.
    private func setTabBar() {
        self.sparkTabBar.select(at: selectedIndex)
        self.sparkTabBar.delegate = self
    }
    
    // MARK: - Layout
    
    /// Set layout.
    private func setLayout() {
        self.view.addSubview(sparkTabBar)
        
        sparkTabBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(self.tabBarHeight + self.bottomSafeArea)
        }
    }
}

// MARK: - SparkTabBarDelegate

extension SparkTabBarController: SparkTabBarDelegate {
    func sparkTabBar(_ sender: SparkTabBar, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }
}
