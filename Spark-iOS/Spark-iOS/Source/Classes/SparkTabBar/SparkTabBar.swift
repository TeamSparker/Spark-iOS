//
//  SparkTabBar.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/13.
//

import UIKit

import SnapKit

/// Implement tab bar with UIView.
final class SparkTabBar: UIView {
    
    // MARK: - Properties
    
    // Use for tab bar select delegate.
    weak var delegate: SparkTabBarDelegate?
    
    var itemsArray: [UITabBarItem] = []
    
    // Called by the system when the tintColor property changes.
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        reloadAppearance()
    }
    
    /// Reload appearance of spark tab bar.
    func reloadAppearance() {
        tabBarItems().forEach { item in
            item.selectedColor = tintColor
        }
    }
    
    /// Use for tab bar.
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 44.0
        
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Set UI.
    private func setUI() {
        self.backgroundColor = .sparkWhite
    }
    
    /// Set layout.
    private func setLayout() {
        self.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(6)
            $0.width.equalTo(232)
            $0.height.equalTo(48)
        }
    }
    
    /// Add tab bar item to items array and compose spark tab bar.
    func add(items tabBarItems: [UITabBarItem]) {
        for tabBarItem in tabBarItems {
            self.itemsArray.append(tabBarItem)
            self.addItem(with: tabBarItem)
        }
    }
    
    /// Add spark tab bar item with tab bar item.
    ///
    /// add spark tab bar item to stack view.
    private func addItem(with item: UITabBarItem) {
        let item = SparkTabBarItem(forItem: item)
        item.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
        item.addGestureRecognizer(tapGestureRecognizer)
        
        // set item's selected color with SparkTabBar's tint color.
        item.selectedColor = self.tintColor
        self.stackView.addArrangedSubview(item)
    }
    
    @objc
    private func itemTapped(_ sender: UITapGestureRecognizer) {
        if let sparkTabBarItem = sender.view as? SparkTabBarItem,
           let index = self.stackView.arrangedSubviews.firstIndex(of: sparkTabBarItem) {
            self.select(at: index)
        }
    }
    
    /// Select item.
    ///
    /// - Parameter notifyDelegate: Value is true when spark tab bar item is selected by tap gesture.
    /// If value is always true, delegate methods are called whenever spark tab bar controller's `selectedIndex` value changes.
    /// So, corresponding parameter is to solve call loop.
    func select(at selectedIndex: Int, notifyDelegate: Bool = true) {
        for (index, item) in self.stackView.arrangedSubviews.enumerated() {
            if let item = item as? SparkTabBarItem {
                item.isSelected = index == selectedIndex ? true : false
            }
        }
        
        if notifyDelegate {
            self.delegate?.sparkTabBar(self, didSelectItemAt: selectedIndex)
        }
    }
    
    // Return items that compose the tab bar.
    private func tabBarItems() -> [SparkTabBarItem] {
        // return array containing non-nil results.
        return self.stackView.arrangedSubviews.compactMap { $0 as? SparkTabBarItem }
    }
}
