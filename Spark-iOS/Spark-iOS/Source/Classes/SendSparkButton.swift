//
//  SendSparkButton.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/02/03.
//

import UIKit

class SendSparkButton: UIButton {
    
    // MARK: - Properties
    
//    enum
    
   // FIXME: - tag 로 대체
    public var identifier: Int = -1
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init(frame: .zero)
        
        setUI()
    }
    
//    override var isSelected {
//        didSet {
//
//        } else {
//
//        }
//    }
}

// MARK: - Methods

extension SendSparkButton {
    private func setUI() {
        self.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 1
        self.setTitleColor(.sparkLightPinkred, for: .normal)
        self.titleLabel?.font = .krMediumFont(ofSize: 14)
    }
}
