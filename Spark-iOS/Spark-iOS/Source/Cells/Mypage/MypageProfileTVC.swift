//
//  MypageProfileTVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/03.
//

import UIKit

class MypageProfileTVC: UITableViewCell {
    
    // MARK: - Properties
    
    private let profileImageView = UIImageView()
    private let profileTextLabel = UILabel()
    private let profileNameLabel = UILabel()
    private let lineView = UIView()
    private let arrowImageView = UIImageView()
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension

extension MypageProfileTVC {
    private func setUI() {
        profileImageView.layer.borderColor = UIColor.sparkLightGray.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.cornerRadius = 32
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        profileTextLabel.text = "프로필"
        profileTextLabel.font = .p2Subtitle
        profileTextLabel.textColor = .sparkDarkGray
        
        profileNameLabel.text = ""
        profileNameLabel.font = .h3Subtitle
        profileNameLabel.textColor = .sparkBlack
        
        arrowImageView.image = UIImage(named: "icArrow")
        
        lineView.backgroundColor = .sparkDarkGray
    }
    
    // initializer.
    func initCell(profile: String?, nickname: String?) {
        profileImageView.updateImage(profile ?? "")
        profileNameLabel.text = nickname ?? ""
    }
}

// MARK: - Layout

extension MypageProfileTVC {
    private func setLayout() {
        self.addSubviews([profileImageView, profileTextLabel, profileNameLabel, arrowImageView, lineView])
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(28)
            $0.width.height.equalTo(64)
        }
        
        profileTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(19)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileTextLabel.snp.bottom).offset(3)
            $0.leading.equalTo(profileTextLabel.snp.leading)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        lineView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
    }
}
