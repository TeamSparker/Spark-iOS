//
//  LeftButtonNavigaitonBar.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/02/17.
//

import Foundation
import UIKit

import SnapKit

/// 좌측 1개의 버튼을 가진 네비게이션 바.
/// - SparkNavigationBar 를 상속 받아서 배경과 title 설정가능하다.
class LeftButtonNavigaitonBar: SparkNavigationBar {
    
    // MARK: - Properties
    
    private var leftButtonClosure: (() -> Void)?
    
    private lazy var leftButton: UIButton = {
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
    func leftButtonImage(_ image: String) -> Self {
        if let image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate) {
            self.leftButton.setImage(image, for: .normal)
        } else {
            print("image is nil.")
        }
        
        return self
    }
    
    /// set title of left button
    @discardableResult
    func leftButtonTitle(_ title: String) -> Self {
        self.leftButton.setTitle(title, for: .normal)
        self.leftButton.titleLabel?.font = .btn1Default
        
        return self
    }
    
    /// set tint color of left button.
    /// - default color is sparkBlack.
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.titleColor(color)
            .leftButton.tintColor = color
        
        return self
    }
    
    /// add action to reft button.
    @discardableResult
    func leftButonAction(_ clousure: (() -> Void)? = nil) -> Self {
        self.leftButtonClosure = clousure
        self.leftButton.addTarget(self, action: #selector(leftButtonSelector), for: .touchUpInside)
        
        return self
    }
    
    // MARK: - @objc Mehotds
    
    @objc
    private func leftButtonSelector() {
        self.leftButtonClosure?()
    }
}
