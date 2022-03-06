//
//  SendSparkButton.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/02/03.
//

import UIKit

public enum SendSparkStatus: Int {
    case message
    case first
    case second
    case third
    case fourth
}

final class SendSparkButton: UIButton {
    
    // MARK: - Properties
    var type: SendSparkStatus?
    var content: String?
    
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
        self.layer.borderColor = UIColor.sparkPinkred.cgColor
        self.layer.cornerRadius = 124 / 2
        self.layer.borderWidth = 1
        self.backgroundColor = .sparkWhite
        self.setTitleColor(.sparkPinkred, for: .normal)
        self.titleLabel?.font = .btn3
        self.titleLabel?.lineBreakMode = .byCharWrapping
        self.titleLabel?.textAlignment = .center
        self.type = type
        
        switch type {
        case .message:
            self.setTitle("""
                          메시지
                          직접 입력하기
                          """,
                          for: .normal)
            self.backgroundColor = .sparkPinkred
            self.setTitleColor(.sparkWhite, for: .normal)
        case .first:
            self.setTitle("""
                          👊
                          아자아자
                          파이팅!
                          """,
                          for: .normal)
            self.content = "👊아자아자 파이팅!"
        case .second:
            self.setTitle("""
                          🔥
                          오늘 안 해?
                          같이 해!
                          """,
                          for: .normal)
            self.content = "🔥오늘 안 해? 같이 해!"
        case .third:
            self.setTitle("""
                          👉
                          너만
                          하면 돼!
                          """,
                          for: .normal)
            self.content = "👉너만 하면 돼!"
        case .fourth:
            self.setTitle("""
                          👍
                          얼마 안 남았어,
                          어서 하자!
                          """,
                          for: .normal)
            self.content = "👍얼마 안 남았어, 어서 하자!"
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
