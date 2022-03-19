//
//  SparkTabBarButton.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/14.
//

import UIKit

import SnapKit

/// Implement the button on the tab bar.
/// - consist of UIImageView, UILabel, and UIView.
final class SparkTabBarItem: UIView {
    
    // MARK: - Properties
    
    private var imageView = UIImageView()
    private var titleLable = UILabel()
    
    /// Whether spark tab bar item is selected.
    var isSelected = false {
        didSet {
            reloadAppearnce()
        }
    }
    
    /// Spark tab bar item's selected color.
    /// - default selected color is spark black.
    var selectedColor: UIColor = .sparkBlack {
        didSet {
            reloadAppearnce()
        }
    }
    
    /// Spark tab bar item's deselected color.
    // - default deselected color is spark dark gray.
    var deselectedColor: UIColor = .sparkDarkGray {
        didSet {
            reloadAppearnce()
        }
    }
    
    // MARK: - Initializer
    
    init(forItem item: UITabBarItem) {
        // set button size to 48*48.
        super.init(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
    
        setUI()
        setItem(image: item.image, title: item.title)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    /// Set UI.
    private func setUI() {
        self.backgroundColor = .clear
        self.imageView.contentMode = .scaleAspectFit
        
        titleLable.font = .caption
    }
    
    /// Set spark tab bar button with UITabBarItem.
    private func setItem(image: UIImage?, title: String?) {
        if let image = image, let title = title {
            imageView.image = image.withRenderingMode(.alwaysTemplate)
            titleLable.text = title
        }
    }
    
    /// Reload spark tab bar item's color.
    private func reloadAppearnce() {
        self.tintColor = isSelected ? selectedColor : deselectedColor
        self.titleLable.textColor = isSelected ? selectedColor : deselectedColor
    }
    
    /// Called when spark tab bar is selected.
    func itemIsSelected() {
        isSelected = isSelected ? true : false
    }
    
    // MARK: - Layout
    
    /// Set layout.
    private func setLayout() {
        self.addSubviews([imageView, titleLable])
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        titleLable.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(1)
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(imageView.snp.centerX)
        }
    }
}
