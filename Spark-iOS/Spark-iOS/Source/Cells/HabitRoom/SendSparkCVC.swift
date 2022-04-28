//
//  SendSparkCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/03/02.
//

import UIKit

import FirebaseAnalytics
import SnapKit

class SendSparkCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var sendSparkCellDelegate: SendSparkCellDelegate?
    
    lazy var sparkButton = SendSparkButton(type: .message) {
        didSet {
            setLayout()
            setAddTarget()
        }
    }
    
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?

    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension SendSparkCVC {
    func setSparkButton(type: SendSparkStatus) {
        self.sparkButton = SendSparkButton(type: type)
    }
    
    private func setLayout() {
        addSubview(sparkButton)
        
        sparkButton.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func setAddTarget() {
        sparkButton.addTarget(self, action: #selector(touchSendSparkButton(_:)), for: .touchUpInside)
    }
    
    private func setFeedbackGenerator() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.selectionChanged()
    }
    
    private func tracking(type: SendSparkStatus) {
        switch type {
        case .message:
            Analytics.logEvent(Tracking.Select.clickSparkInputText, parameters: nil)
        case .first:
            Analytics.logEvent(Tracking.Select.clickSparkFighting, parameters: nil)
        case .second:
            Analytics.logEvent(Tracking.Select.clickSparkTogether, parameters: nil)
        case .third:
            Analytics.logEvent(Tracking.Select.clickSparkUonly, parameters: nil)
        case .fourth:
            Analytics.logEvent(Tracking.Select.clickSparkHurry, parameters: nil)
        }
    }
    
    // MARK: - @objc Function
    
    @objc
    func touchSendSparkButton(_ sender: SendSparkButton) {
        if sender.type == .message {
            sendSparkCellDelegate?.showTextField()
        } else {
            sendSparkCellDelegate?.sendSpark(sender.content ?? "")
        }
    
        tracking(type: sender.type ?? .message)
    }
}
