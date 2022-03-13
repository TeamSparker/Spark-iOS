//
//  SparkTabBarButton.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/14.
//

import UIKit

import SnapKit

/// Implement the button on the tab bar.
/// - consist of UIImageView and UILabel.
final class SparkTabBarItem: UIView {
    
    // MARK: - Properties
    
    private var imageView = UIImageView()
    private var titleLable = UILabel()
    
    var isSelected = false {
        didSet {
            reloadAppearnce()
        }
    }
    
    // default selected color is spark black.
    var selectedColor: UIColor = .sparkBlack {
        didSet {
            reloadAppearnce()
        }
    }
    
    // default deselected color is spark dark gray.
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
    
    private func setUI() {
        self.backgroundColor = .clear
        self.imageView.contentMode = .scaleAspectFit
        
        titleLable.font = .caption
    }
    
    /// set spark tab bar button with UITabBarItem.
    private func setItem(image: UIImage?, title: String?) {
        if let image = image, let title = title {
            imageView.image = image.withRenderingMode(.alwaysOriginal)
            titleLable.text = title
        }
    }
    
    /// reload tint color.
    private func reloadAppearnce() {
        self.tintColor = isSelected ? selectedColor : deselectedColor
        // FIXME: - 혹시 여기서 이미지뷰랑 텍스트 색도 변경해줘야하나? 틴트컬러만 세팅해주면되나..?
    }
    
    /// called when spark tab bar is selected.
    func itemIsSelected() {
        isSelected = isSelected ? true : false
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        self.addSubviews([imageView, titleLable])
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        titleLable.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(1)
            $0.bottom.equalToSuperview()
        }
    }
}
