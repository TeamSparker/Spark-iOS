//
//  WaitingVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//

import UIKit

class WaitingVC: UIViewController {
    
    // MARK: - Properties
    
    let copyButton = UIButton()
    let checkTitleLabel = UILabel()
    let toolTipButton = UIButton()
    let stopwatchLabel = UILabel()
    let checkDivideView = UIView()
    let photoLabel = UILabel()
    let firstDivideLabel = UIView()
    
    let goalTitleLabel = UILabel()
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let timeLabel = UILabel()
    let goalLabel = UILabel()
    let editButton = UIButton()
    let secondDivideLabel = UIView()
    
    let friendTitleLabel = UILabel()
    let friendCountLabel = UILabel()
    let friendSubTitleLabel = UILabel()
//    let collectionView = UICollectionView()
    let refreshButton = UIButton()
    
    let startButton = UIButton()

    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
    }
    
    func setUI() {
        copyButton.backgroundColor = .blue
        toolTipButton.backgroundColor = .purple
        editButton.backgroundColor = .orange
        profileImageView.backgroundColor = .sparkBrightPinkred
        refreshButton.backgroundColor = .sparkBrightPinkred
        startButton.backgroundColor = .green
        firstDivideLabel.backgroundColor = .sparkDarkGray
        secondDivideLabel.backgroundColor = .sparkDarkGray
        checkDivideView.backgroundColor = .sparkDarkGray
        
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.cornerRadius = 32
        
        checkTitleLabel.text = "습관 인증 방식"
        photoLabel.text = "사진 인증"
        stopwatchLabel.text = "스톱워치"
        goalTitleLabel.text = "나의 목표"
        nicknameLabel.text = "힛이"
        timeLabel.text = "시간  잠들기 전에"
        goalLabel.text = "목표  일단 책부터 펴자!"
        friendTitleLabel.text = "함께하는 스파커들"
        friendCountLabel.text = "10"
        friendSubTitleLabel.text = "습관을 시작한 후에는 인원 추가가 불가능합니다."
        
        checkTitleLabel.font = .h2Title
        photoLabel.font = .p1TitleLight
        stopwatchLabel.font = .p1TitleLight
        goalTitleLabel.font = .h2Title
        nicknameLabel.font = .h3Subtitle
        timeLabel.font = .p1TitleLight
        goalLabel.font = .p1TitleLight
        friendTitleLabel.font = .h2Title
        friendCountLabel.font = .p2SubtitleEng
        friendSubTitleLabel.font = .p2Subtitle
        
        timeLabel.medium(targetString: "시간")
        goalLabel.medium(targetString: "목표")
        
        [checkTitleLabel, goalTitleLabel, friendTitleLabel,
         nicknameLabel, friendCountLabel, timeLabel, goalLabel].forEach {
            $0.textColor = .sparkDeepGray
        }
        
        [photoLabel, stopwatchLabel].forEach {
            $0.textColor = .sparkDarkGray
        }
        
        friendSubTitleLabel.textColor = .gray
    }
    
    func setLayout() {
        view.addSubviews([copyButton, checkTitleLabel, toolTipButton,
                         stopwatchLabel, checkDivideView, photoLabel,
                          firstDivideLabel, goalTitleLabel, profileImageView,
                          nicknameLabel, timeLabel, goalLabel, editButton,
                         secondDivideLabel, friendTitleLabel, friendCountLabel,
                          friendSubTitleLabel, refreshButton, startButton]) /// collectionView
        
        copyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().inset(13)
            make.top.equalToSuperview().inset(104)
            make.width.equalTo(87)
            make.height.equalTo(36)
        }
        
        checkTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(copyButton.snp.bottom).offset(36)
        }
        
        toolTipButton.snp.makeConstraints { make in
            make.leading.equalTo(checkTitleLabel.snp.trailing).offset(4)
            make.centerY.equalTo(checkTitleLabel.snp.centerY)
            make.width.height.equalTo(24)
        }
        
        photoLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(checkTitleLabel.snp.centerY)
        }
        
        checkDivideView.snp.makeConstraints { make in
            make.trailing.equalTo(photoLabel.snp.leading).offset(-8)
            make.centerY.equalTo(photoLabel.snp.centerY)
            make.width.equalTo(8)
            make.height.equalTo(1)
        }
        
        stopwatchLabel.snp.makeConstraints { make in
            make.trailing.equalTo(checkDivideView.snp.leading).offset(-8)
            make.centerY.equalTo(photoLabel.snp.centerY)
        }
        
        firstDivideLabel.snp.makeConstraints { make in
            make.top.equalTo(checkTitleLabel.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        goalTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(firstDivideLabel.snp.bottom).offset(33)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(goalTitleLabel.snp.centerY)
            make.width.height.equalTo(44)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(goalTitleLabel.snp.bottom).offset(36)
            make.width.height.equalTo(64)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(-12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(15)
            make.leading.equalTo(nicknameLabel.snp.leading)
        }
        
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(4)
            make.leading.equalTo(nicknameLabel.snp.leading)
        }
        
        secondDivideLabel.snp.makeConstraints { make in
            make.top.equalTo(goalLabel.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        friendTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(secondDivideLabel.snp.bottom).offset(32)
        }
        
        friendCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(friendTitleLabel.snp.trailing).offset(4)
            make.bottom.equalTo(friendTitleLabel.snp.bottom)
        }
        
        friendSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(friendTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(friendTitleLabel.snp.centerY)
            make.width.height.equalTo(44)
        }
        
//        collectionView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(friendSubTitleLabel.snp.bottom).offset(24)
//            make.height.equalTo(85)
//        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(54)
            make.height.equalTo(48)
        }
    }
}

extension UILabel {
    func medium(targetString: String) {
        let font = UIFont.p1Title
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
}
