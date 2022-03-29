//
//  NotificationTVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/27.
//

import UIKit

import SnapKit

class NotificationTVC: UITableViewCell {

    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let notificationSwitch = UISwitch()
    private let lineView = UIView()
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setAddTargets()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        subtitleLabel.text = ""
        notificationSwitch.isOn = false
        lineView.isHidden = false
    }
}

extension NotificationTVC {
    private func setUI() {
        titleLabel.font = .p1Title
        titleLabel.textColor = .sparkBlack
        
        subtitleLabel.font = .caption
        subtitleLabel.textColor = .sparkDarkGray
        
        notificationSwitch.isOn = false
        
        lineView.backgroundColor = .sparkGray
    }
    
    // cell initializer.
    public func initCell(with type: NotificationTableRow, isOn: Bool) {
        notificationSwitch.isOn = isOn
        
        switch type {
        case .roomStart:
            titleLabel.text = "습관방 시작"
            subtitleLabel.text = "대기 중이었던 방이 시작되면 바로 알 수 있어요."
            lineView.isHidden = false
        case .spark:
            titleLabel.text = "스파크 보내기"
            subtitleLabel.text = "받은 스파크를 확인할 수 있어요."
            lineView.isHidden = true
        case .consider:
            titleLabel.text = "고민중"
            subtitleLabel.text = "다른 스파커가 고민중인 경우 바로 알 수 있어요."
            lineView.isHidden = true
        case .certification:
            titleLabel.text = "인증 완료"
            subtitleLabel.text = "스파커들의 인증 사진을 바로 확인할 수 있어요."
            lineView.isHidden = false
        case .remind:
            titleLabel.text = "미완료 습관방"
            subtitleLabel.text = "21:00에 미완료된 방이 있을 경우 알 수 있어요."
            lineView.isHidden = true
        }
    }
    
    private func setAddTargets() {
        notificationSwitch.addTarget(self, action: #selector(touchNotificationSwitch), for: .touchUpInside)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func touchNotificationSwitch() {
    // TODO: - network
    }
}

// MARK: - Layout

extension NotificationTVC {
    private func setLayout() {
        self.contentView.addSubviews([titleLabel, subtitleLabel, notificationSwitch, lineView])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        notificationSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(51)
            $0.top.equalTo(titleLabel.snp.top).offset(10)
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
