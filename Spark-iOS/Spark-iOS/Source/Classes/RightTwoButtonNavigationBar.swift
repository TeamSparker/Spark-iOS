//
//  RightTwoButtonNavigationBar.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/02/17.
//

import Foundation
import UIKit

class RightTwoButtonNavigationBar: SparkNavigationBar {
    
    // MARK: - Properties
    
    lazy var firstRightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(), for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = .sparkBlack
        
        return button
    }()
    
    lazy var secondRightButton: UIButton = {
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
        self.addSubviews([firstRightButton, secondRightButton])
        
        secondRightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        firstRightButton.snp.makeConstraints {
            $0.trailing.equalTo(secondRightButton.snp.leading).offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    /// set image of first, second button.
    /// - default image is UIImage()
    @discardableResult
    func setButtonsImage(_ firstButtonImage: UIImage?, _ secondButtonImage: UIImage?) -> Self {
        if let firstButtonImage = firstButtonImage, let secondButtonImage = secondButtonImage {
            self.firstRightButton.setImage(firstButtonImage, for: .normal)
            self.secondRightButton.setImage(secondButtonImage, for: .normal)
        }
        
        return self
    }
    
    /// add action to first, second button.
    @discardableResult
    func addTargetButtons(_ firstSelector: Selector, _ secondSelector: Selector) -> Self {
        self.firstRightButton.addTarget(self, action: firstSelector, for: .touchUpInside)
        self.secondRightButton.addTarget(self, action: secondSelector, for: .touchUpInside)
        
        return self
    }
}
