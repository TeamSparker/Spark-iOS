//
//  NotificationTVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/27.
//

import UIKit

class NotificationTVC: UITableViewCell {

    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let switchControl = UISwitch()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        subtitleLabel.text = ""
        switchControl.isOn = false
    }
}

extension NotificationTVC {
    private func setUI() {
        titleLabel.font = .p1Title
        titleLabel.textColor = .sparkBlack
        
        subtitleLabel.font = .caption
        subtitleLabel.textColor = .sparkDarkGray
        
        switchControl.isOn = false
    }
    
    // cell initializer.
    public func initCell(with type: NotificationTableRow, isOn: Bool) {
        switch type {
        case .roomStart:
            titleLabel.text = "습관방 시작"
            subtitleLabel.text = "대기 중이었던 방이 시작되면 바로 알 수 있어요."
            switchControl.isOn = isOn
        case .spark:
            titleLabel.text = "스파크 보내기"
            subtitleLabel.text = "받은 스파크를 확인할 수 있어요."
            switchControl.isOn = isOn
        case .consider:
            titleLabel.text = "고민중"
            subtitleLabel.text = "다른 스파커가 고민중인 경우 바로 알 수 있어요."
            switchControl.isOn = isOn
        case .certification:
            titleLabel.text = "인증 완료"
            subtitleLabel.text = "스파커들의 인증 사진을 바로 확인할 수 있어요."
            switchControl.isOn = isOn
        case .remind:
            titleLabel.text = "미완료 습관방"
            subtitleLabel.text = "21:00에 미완료된 방이 있을 경우 알 수 있어요."
            switchControl.isOn = isOn
        }
    }
}

// MARK: - Layout

extension NotificationTVC {
    private func setLayout() {
        self.contentView.addSubviews([titleLabel, subtitleLabel, switchControl])
        
        
    }
}
