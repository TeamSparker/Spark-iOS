//
//  MypageDefaultTVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/03.
//

import UIKit

class MypageDefaultTVC: UITableViewCell {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let withdrawalButton = UIButton()
    private let versionLabel = UILabel()
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        titleLabel.isHidden = true
        
        arrowImageView.isHidden = true
        
        withdrawalButton.isHidden = true
        
        versionLabel.isHidden = true
    }
}

// MARK: - Extension

extension MypageDefaultTVC {
    private func setUI() {
        titleLabel.text = ""
        titleLabel.font = .p1Title
        titleLabel.textColor = .sparkBlack
        
        arrowImageView.image = UIImage(named: "icArrow")
        
        let attributeString = NSMutableAttributedString(string: "회원 탈퇴")
        attributeString.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        withdrawalButton.setAttributedTitle(attributeString, for: .normal)
        withdrawalButton.titleLabel?.font = .caption
        withdrawalButton.setTitleColor(.sparkGray, for: .normal)
        
        // local update. > next version v1.0.1
        versionLabel.text = " v1.0.0"
        versionLabel.font = .captionEng
        versionLabel.textColor = .sparkDarkGray
    }
    
    // initializer.
    func initCell(type: MypageRow) {
        switch type {
        case .profile:
            return
        case .notification:
            titleLabel.text = "알림"
            
            titleLabel.isHidden = false
            arrowImageView.isHidden = false
            versionLabel.isHidden = true
            withdrawalButton.isHidden = true
        case .contact:
            titleLabel.text = "문의하기"
            titleLabel.isHidden = false
            arrowImageView.isHidden = false
            versionLabel.isHidden = true
            withdrawalButton.isHidden = true
        case .sparkGuide:
            titleLabel.text = "스파크 사용 가이드"
            titleLabel.isHidden = false
            arrowImageView.isHidden = false
            versionLabel.isHidden = true
            withdrawalButton.isHidden = true
        case .tos:
            titleLabel.text = "약관 및 정책"
            titleLabel.isHidden = false
            arrowImageView.isHidden = false
            versionLabel.isHidden = true
            withdrawalButton.isHidden = true
        case .version:
            titleLabel.text = "버전 정보"
            titleLabel.isHidden = false
            arrowImageView.isHidden = true
            versionLabel.isHidden = false
            withdrawalButton.isHidden = true
        case .logout:
            titleLabel.text = "로그아웃"
            titleLabel.isHidden = false
            arrowImageView.isHidden = true
            versionLabel.isHidden = true
            withdrawalButton.isHidden = true
        case .withdrawal:
            titleLabel.isHidden = true
            arrowImageView.isHidden = true
            versionLabel.isHidden = true
            withdrawalButton.isHidden = false
        }
    }
}

// MARK: - Layout

extension MypageDefaultTVC {
    private func setLayout() {
        self.addSubviews([titleLabel, arrowImageView, versionLabel, withdrawalButton])
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        versionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}
