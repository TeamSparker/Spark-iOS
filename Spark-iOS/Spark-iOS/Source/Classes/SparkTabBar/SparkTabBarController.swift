//
//  SparkTabBarController.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/14.
//

import UIKit

class SparkTabBarController: UITabBarController {
    
    // MARK: - IBInspectable
    
    @IBInspectable
    public var tintColor: UIColor? {
        didSet {
            self.sparkTabBar.tintColor = tintColor
            self.sparkTabBar.reloadAppearance()
        }
    }
    
    @IBInspectable
    public var backgroundColor: UIColor? {
        didSet {
            self.sparkTabBar.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Properties
    
    private let tabBarHeight: CGFloat = 54.0
    
    public let sparkTabBar: SparkTabBar = {
        return SparkTabBar()
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setTabBar()
    }
    
    private func setUI() {
        self.tabBar.isHidden = true
    }
    
    private func setTabBar() {
        self.sparkTabBar.select(at: selectedIndex)
        self.sparkTabBar.delegate = self
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        self.view.addSubview(sparkTabBar)
        
        sparkTabBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(self.tabBarHeight)
        }
    }
}

// MARK: - SparkTabBarDelegate

extension SparkTabBarController: SparkTabBarDelegate {
    func sparkTabBar(_ sender: SparkTabBar, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }
}
