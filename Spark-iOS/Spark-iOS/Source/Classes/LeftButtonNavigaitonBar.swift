//
//  LeftButtonNavigaitonBar.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/02/17.
//

import Foundation
import UIKit

class LeftButtonNavigaitonBar: SparkNavigationBar {
    
    // MARK: - Properties
    
    lazy var leftButton: UIButton = {
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
        
        self.leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    /// set image of left button.
    /// - default image is UIImage().
    @discardableResult
    func setLeftButtonImage(_ image: UIImage?) -> Self {
        if let image = image {
            self.leftButton.setImage(image, for: .normal)
        }
        
        return self
    }
    
    /// set tint color of left button
    /// - default color is sparkBlack.
    @discardableResult
    func setTintColor(_ color: UIColor) -> Self {
        self.setTitleColor(color)
            .leftButton.tintColor = color
        
        return self
    }
}
