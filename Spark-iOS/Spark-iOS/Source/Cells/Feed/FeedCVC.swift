//
//  FeedCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/12.
//

import UIKit

import SnapKit

class FeedCVC: UICollectionViewCell {
    static let identifier = "FeedCVC"
    
    // MARK: - Properties
    
    let feedImageView = UIImageView()
    let fadeImageView = UIImageView()
    let timeLabel = UILabel()
    let profileImageView = UIImageView()
    let nameLabel = UILabel() /// 힛이
    
    let titleStackView = UIStackView() /// titleLabel, doneImageView
    let titleLabel = UILabel() /// 아침 독서
    let doneImageView = UIImageView() /// done
    
    let sparkStackView = UIStackView() /// 받은 스파크 + icon + 12
    let sparkLabel = UILabel() /// 받은 스파크 개수
    let sparkIconImageView = UIImageView()
    let sparkCountLabel = UILabel() /// 12
    
    // FIXME: - button으로 변경
    let heartImageView = UIImageView()
    let heartCountLabel = UILabel()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setStackView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setUI() {
        feedImageView.backgroundColor = .yellow
        profileImageView.backgroundColor = .black
        fadeImageView.backgroundColor = .sparkBlack.withAlphaComponent(0.15)
        
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.cornerRadius = 32
        
        sparkLabel.text = "받은 스파크"
        // TODO: - 서버 데이터 연결 후 삭제
        timeLabel.text = "00:30:18"
        nameLabel.text = "힛이"
        titleLabel.text = "아침 독서"
        sparkCountLabel.text = "12"
        heartCountLabel.text = "21"
        
        timeLabel.font = .enBoldFont(ofSize: 40)
        nameLabel.font = .p1Title
        titleLabel.font = .krBoldFont(ofSize: 20)
        sparkCountLabel.font = .p2SubtitleEng
        heartCountLabel.font = .h2TitleEng
        
        timeLabel.textColor = .sparkWhite
        nameLabel.textColor = .sparkDeepGray
        titleLabel.textColor = .sparkDeepGray
        sparkLabel.textColor = .sparkDarkGray
        sparkCountLabel.textColor = .sparkDarkGray
        heartCountLabel.textColor = .sparkGray
        
        doneImageView.image = UIImage(named: "tagDone")
        sparkIconImageView.image = UIImage(named: "icFire")
        heartImageView.image = UIImage(named: "icHeartInactive")
    }
    
    func setStackView() {
        titleStackView.axis = .horizontal
        titleStackView.alignment = .fill
        titleStackView.distribution = .equalSpacing
        titleStackView.spacing = 8
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(doneImageView)
        
        sparkStackView.axis = .horizontal
        sparkStackView.alignment = .fill
        sparkStackView.distribution = .equalSpacing
        sparkStackView.spacing = 3
        sparkStackView.addArrangedSubview(sparkLabel)
        sparkStackView.addArrangedSubview(sparkIconImageView)
        sparkStackView.addArrangedSubview(sparkCountLabel)
    }
    
    func setLayout() {
        self.addSubviews([feedImageView, fadeImageView, profileImageView,
                          nameLabel, titleStackView, timeLabel,
                          sparkStackView, heartImageView, heartCountLabel])
        
        feedImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(feedImageView.snp.width).multipliedBy(1.0 / 1.0)
        }
        
        fadeImageView.snp.makeConstraints { make in
            make.edges.equalTo(feedImageView.snp.edges)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.center.equalTo(feedImageView.snp.center)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(feedImageView.snp.bottom)
            make.width.height.equalTo(64)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        sparkStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleStackView.snp.bottom).offset(8)
        }
        
        sparkIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
        
        heartImageView.snp.makeConstraints { make in
            make.top.equalTo(feedImageView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(50)
        }
        
        heartCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(heartImageView.snp.trailing).offset(5)
            make.centerY.equalTo(heartImageView.snp.centerY)
        }
    }
}
