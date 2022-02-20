//
//  LeftRightButtonsNavigationBar.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/02/17.
//

import Foundation
import UIKit

import SnapKit

/// 좌측, 우측 버튼을 가지는 네비게이션 바.
/// - SparkNavigationBar 를 상속 받아서 배경과 title 설정가능하다.
final class LeftRightButtonsNavigationBar: LeftButtonNavigaitonBar {
    
    // MARK: - Properties
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(), for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = .sparkBlack
        
        return button
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        setLayout()
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        self.addSubview(leftButton)
        
        self.rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    /// set image of left button.
    /// - default image is UIImage().
    @discardableResult
    func rightButtonImage(_ image: UIImage?) -> Self {
        if let image = image {
            self.rightButton.setImage(image, for: .normal)
        } else {
            print("image is nil.")
        }
        
        return self
    }
    
    /// set tint color of left button.
    /// - default color is sparkBlack.
    @discardableResult
    override func tintColor(_ color: UIColor) -> Self {
        super.tintColor(color)
            .rightButton.tintColor = color
        
        return self
    }
    
    /// add action to right button.
    @discardableResult
    func actions(_ rightButtonSelector: Selector) -> Self {
        self.rightButton.addTarget(self, action: rightButtonSelector, for: .touchUpInside)
        
        return self
    }
}
