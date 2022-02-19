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
//        fatalError("init(coder:) has not been implemented")
        setUI()
        setLayout()
    }
    
    // MARK: - Method
    
    func setBottomButtonTitle(title: String) {
        setTitle(title, for: .normal)
    }
    
    private func setUI() {
        backgroundColor = .sparkDarkPinkred
        titleLabel?.font = .enBoldFont(ofSize: 18)
        layer.cornerRadius = 2
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width * 48 / 335)
        }
    }
}
