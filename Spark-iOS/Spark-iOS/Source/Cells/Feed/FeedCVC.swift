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
    let nameLabel = UILabel()
    
    let titleStackView = UIStackView()
    let titleLabel = UILabel()
    let doneImageView = UIImageView()
    
    let sparkStackView = UIStackView()
    let sparkLabel = UILabel()
    let sparkIconImageView = UIImageView()
    let sparkCountLabel = UILabel()
    
    let likeButton = UIButton()
    let likeCountLabel = UILabel()
    
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
    
    override func prepareForReuse() {
        titleLabel.text = ""
        nameLabel.text = ""
        sparkCountLabel.text = ""
        likeCountLabel.text = ""
        timeLabel.text = ""
        feedImageView.image = UIImage()
        profileImageView.image = UIImage()
    }
    
    // MARK: - Methods
    func initCell(title: String, nickName: String, timeRecord: String?, likeCount: Int, sparkCount: Int, profileImg: String?, certifyingImg: String, hasTime: Bool, isLiked: Bool) {
        titleLabel.text = "\(title)"
        nameLabel.text = "\(nickName)"
        sparkCountLabel.text = "\(sparkCount)"
        likeCountLabel.text = "\(likeCount)"
        feedImageView.updateImage(certifyingImg)
        
        if let profile = profileImg {
            profileImageView.updateImage(profile)
        } else {
            profileImageView.image = UIImage(named: "profileEmpty")
        }
        
        if let time = timeRecord {
            timeLabel.text = "\(time)"
        } else {
            timeLabel.text = ""
        }
        
        if isLiked {
            likeButton.setImage(UIImage(named: "icHeartActive"), for: .normal)
            likeCountLabel.textColor = .sparkDarkPinkred
        } else {
            likeButton.setImage(UIImage(named: "icHeartInactive"), for: .normal)
            likeCountLabel.textColor = .sparkGray
        }
    }
    
    private func setUI() {
        self.backgroundColor = .white
        
        fadeImageView.backgroundColor = .sparkBlack.withAlphaComponent(0.15)
        
        profileImageView.backgroundColor = .sparkGray
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.cornerRadius = 32
        profileImageView.layer.masksToBounds = true
        
        sparkLabel.text = "받은 스파크"
        
        timeLabel.font = .enBoldFont(ofSize: 40)
        nameLabel.font = .p1Title
        titleLabel.font = .krBoldFont(ofSize: 20)
        sparkCountLabel.font = .p2SubtitleEng
        likeCountLabel.font = .h2TitleEng
        
        timeLabel.textColor = .sparkWhite
        nameLabel.textColor = .sparkDeepGray
        titleLabel.textColor = .sparkDeepGray
        sparkLabel.textColor = .sparkDarkGray
        sparkCountLabel.textColor = .sparkDarkGray
        likeCountLabel.textColor = .sparkGray
        
        doneImageView.image = UIImage(named: "tagDone")
        sparkIconImageView.image = UIImage(named: "icFire")
        likeButton.setImage(UIImage(named: "icHeartInactive"), for: .normal)
    }
    
    private func setStackView() {
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
    
    private func setLayout() {
        self.addSubviews([feedImageView, fadeImageView, profileImageView,
                          nameLabel, titleStackView, timeLabel,
                          sparkStackView, likeButton, likeCountLabel])
        
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
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(feedImageView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(50)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(5)
            make.centerY.equalTo(likeButton.snp.centerY)
        }
    }
}
