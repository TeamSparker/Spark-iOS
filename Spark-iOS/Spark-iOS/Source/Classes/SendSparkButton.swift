//
//  SendSparkButton.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/02/03.
//

import UIKit

@frozen
public enum SendSparkStatus: Int {
    case message
    case first
    case second
    case third
    case fourth
}

final class SendSparkButton: UIButton {
    
    // MARK: - Properties
    
    var type: SendSparkStatus {
        didSet {
            self.setContent()
        }
    }
    var content: String?
    
    // MARK: - Initialize
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: SendSparkStatus) {
        self.type = type
        super.init(frame: .zero)
        setUI(self.type)
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
    }
    
    private func setContent() {
        switch self.type {
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
}
