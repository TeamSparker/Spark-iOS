//
//  SparkTabBar.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/13.
//

import UIKit

import SnapKit

/// Custom Tab Bar.
final class SparkTabBar: UIView {
    
    // MARK: - Properties
    
    // use for tab bar select delegate.
    weak var delegate: SparkTabBarDelegate?
    
    var items: [UITabBarItem] = [] {
        didSet {
            // notify with delegate.
            select(at: 0)
        }
    }
    
    // called by the system when the tintColor property changes.
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        reloadAppearance()
    }
    
    func reloadAppearance() {
        tabBarItems().forEach { item in
            item.selectedColor = tintColor
        }
    }
    
    /// use for tab bar.
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 44
        
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// set UI.
    private func setUI() {
        self.backgroundColor = .sparkWhite
    }
    
    // FIXME: -  deinit
//    deinit {
//
//    }
    
    /// set layout.
    private func setLayout() {
        self.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(6)
            $0.bottom.equalToSuperview()
        }
    }
    
    func add(item: UITabBarItem) {
        self.items.append(item)
        self.addItem(with: item)
    }
    
    private func addItem(with item: UITabBarItem) {
        let item = SparkTabBarItem(forItem: item)
        let tapGestureRecognizer = UITapGestureRecognizer(target: item, action: #selector(itemTapped(_:)))
        item.isUserInteractionEnabled = true
        item.addGestureRecognizer(tapGestureRecognizer)
        
        // set item's selected color with SparkTabBar tint color.
        item.selectedColor = self.tintColor
        self.stackView.addArrangedSubview(item)
    }
    
    @objc
    private func itemTapped(_ sender: SparkTabBarItem) {
        if let index = self.stackView.arrangedSubviews.firstIndex(of: sender) {
            self.select(at: index)
        }
    }
    
    /// select item.
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
    
    // return items that compose the tab bar.
    private func tabBarItems() -> [SparkTabBarItem] {
        // return array containing non-nil results.
        return self.stackView.arrangedSubviews.compactMap { $0 as? SparkTabBarItem }
    }
}
