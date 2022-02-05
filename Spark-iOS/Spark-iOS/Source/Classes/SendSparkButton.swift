//
//  SendSparkButton.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/02/03.
//

import UIKit

final
class SendSparkButton: UIButton {
    
    // MARK: - Properties
    
    public enum SendSparkStatus {
        case first
        case second
        case third
        case fourth
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(type: SendSparkStatus) {
        super.init(frame: .zero)
        
        setUI(type)
    }
}

// MARK: - Methods

extension SendSparkButton {
    private func setUI(_ type: SendSparkStatus) {
        self.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 1
        self.setTitleColor(.sparkLightPinkred, for: .normal)
        self.titleLabel?.font = .krMediumFont(ofSize: 14)
        
        switch type {
        case .first:
            self.setTitle("👊 아자아자 파이팅!", for: .normal)
            self.tag = 1
        case .second:
            self.setTitle("🔥오늘 안 해? 같이 해!", for: .normal)
            self.tag = 2
        case .third:
            self.setTitle("👉 너만 하면 돼!", for: .normal)
            self.tag = 3
        case .fourth:
            self.setTitle("👍 얼마 안 남았어, 어서 하자!", for: .normal)
            self.tag = 4
        }
    }
    
    public func isSelected(_ isSelected: Bool) {
        if isSelected {
            self.setTitleColor(.sparkDarkPinkred, for: .normal)
            self.backgroundColor = .sparkMostLightPinkred
            self.titleLabel?.backgroundColor = .sparkMostLightPinkred
            self.layer.borderColor = UIColor.sparkDarkPinkred.cgColor
        } else {
            self.setTitleColor(.sparkLightPinkred, for: .normal)
            self.backgroundColor = .sparkWhite
            self.titleLabel?.backgroundColor = .sparkWhite
            self.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        }
    }
}
