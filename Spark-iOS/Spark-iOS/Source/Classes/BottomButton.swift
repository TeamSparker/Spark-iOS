//
//  BottomButton.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/02/19.
//

import UIKit

import SnapKit

@frozen
enum BottomButtonType {
    case pink
    case white
}

class BottomButton: UIButton {

    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayout()
    }
    
    // MARK: - Method
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.height.equalTo((UIScreen.main.bounds.width - 40) * 48 / 335)
        }
    }
    
    @discardableResult
    func setUI(_ type: BottomButtonType) -> Self {
        
        titleLabel?.font = .enBoldFont(ofSize: 18)
        layer.cornerRadius = 2
        
        switch type {
        case .pink:
            backgroundColor = .sparkDarkPinkred
        case .white:
            backgroundColor = .sparkWhite
            setTitleColor(.sparkDarkPinkred, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.sparkDarkPinkred.cgColor
        }
        
        return self
    }
    
    @discardableResult
    func setTitle(_ title: String) -> Self {
        self.setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    func setAble() -> Self {
        self.backgroundColor = .sparkDarkPinkred
        self.isEnabled = true
        return self
    }
    
    @discardableResult
    func setDisable() -> Self {
        self.backgroundColor = .sparkGray
        self.isEnabled = false
        return self
    }
}
