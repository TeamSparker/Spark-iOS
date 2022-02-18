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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String) {
        super.init(frame: .zero)
        
        setUI(title: title)
        setLayout()
    }
    
    // MARK: - Custom Method
    
    private func setUI(title: String) {
        backgroundColor = .sparkPinkred
        setTitle(title, for: .normal)
        titleLabel?.font = .enBoldFont(ofSize: 18)
        layer.cornerRadius = 2
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width * 48 / 335)
        }
    }
    
    func changeButtonTitle(title: String) {
        setTitle(title, for: .normal)
    }
}
