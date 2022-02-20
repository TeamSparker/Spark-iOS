//
//  BottomButton.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/02/19.
//

import UIKit

class BottomButton: UIButton {

    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setLayout()
    }
    
    // MARK: - Method
    
    private func setUI() {
        backgroundColor = .sparkDarkPinkred
        titleLabel?.font = .enBoldFont(ofSize: 18)
        layer.cornerRadius = 2
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.height.equalTo((UIScreen.main.bounds.width - 40) * 48 / 335)
        }
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
