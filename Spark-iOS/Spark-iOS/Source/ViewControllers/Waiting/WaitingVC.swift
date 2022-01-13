//
//  WaitingVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//

import UIKit

import SnapKit

class WaitingVC: UIViewController {
    
    // MARK: - Dummy Data
    var dummydata = [
        "roomId": 1,
        "roomName": "미라클 모닝",
        "roomCode": "abcdefghij",
        "fromStart": false,
        "isSet": false,
        "momentDetail": "",
        "moment": "잠깨기 전에",
        "purpose": "집에 가자",
        "members": [
            [
                "userId": 1,
                "nickname": "힛이",
                "profileImg": "https://storage.googleapis.com/we-sopt-29-server.appspot.com/...",
            ],
            [
                "userId": 2,
                "nickname": "수아",
                "profileImg": "https://storage.googleapis.com/we-sopt-29-server.appspot.com/...",
            ],
            [
                "userId": 3,
                "nickname": "애진",
                "profileImg": "https://storage.googleapis.com/we-sopt-29-server.appspot.com/...",
            ],
            [
                "userId": 4,
                "nickname": "뚜비",
                "profileImg": "https://storage.googleapis.com/we-sopt-29-server.appspot.com/...",
            ],
            [
                "userId": 5,
                "nickname": "나나",
                "profileImg": "https://storage.googleapis.com/we-sopt-29-server.appspot.com/...",
            ],
            [
                "userId": 6,
                "nickname": "뽀",
                "profileImg": "https://storage.googleapis.com/we-sopt-29-server.appspot.com/...",
            ],
            [
                "userId": 7,
                "nickname": "보라돌이",
                "profileImg": "https://storage.googleapis.com/we-sopt-29-server.appspot.com/...",
            ],
        ]
    ] as [String : Any] as [String : Any] as [String : Any]
    
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
    let refreshButton = UIButton()
    let startButton = UIButton()
    
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    var memberList: [Any] = []
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
        setUI()
        setLayout()
        setCollectionView()
        setAddTarget()
    }
    
    func setUI() {
        profileImageView.backgroundColor = .purple
        firstDivideLabel.backgroundColor = .sparkDarkGray.withAlphaComponent(0.5)
        secondDivideLabel.backgroundColor = .sparkDarkGray.withAlphaComponent(0.5)
        checkDivideView.backgroundColor = .sparkDarkGray
        
        copyButton.setImage(UIImage(named: "btnSmall"), for: .normal)
        toolTipButton.setImage(UIImage(named: "icInformation"), for: .normal)
        editButton.setImage(UIImage(named: "btnEdit"), for: .normal)
        refreshButton.setImage(UIImage(named: "btnRefresh"), for: .normal)
        startButton.setImage(UIImage(named: "btnPrimary"), for: .normal)
        
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.cornerRadius = 32

        checkTitleLabel.text = "습관 인증 방식"
        photoLabel.text = "사진 인증"
        stopwatchLabel.text = "스톱워치"
        goalTitleLabel.text = "나의 목표"
        nicknameLabel.text = "힛이"
        friendTitleLabel.text = "함께하는 스파커들"
        friendSubTitleLabel.text = "습관을 시작한 후에는 인원 추가가 불가능합니다."
        
        if let fromstart = dummydata["fromStart"]  {
            if !(fromstart as! Bool) {
                [stopwatchLabel, checkDivideView].forEach { $0.isHidden = true }
            } else {
                [stopwatchLabel, checkDivideView].forEach { $0.isHidden = false }
            }
        }
        
        // FIXME: - 강제언래핑 제거
        timeLabel.text = "시간  \(String(describing: dummydata["moment"]!))"
        goalLabel.text = "목표  \(String(describing: dummydata["purpose"]!))"
        friendCountLabel.text = "\(memberList.count)"
        
        nicknameLabel.font = .h3Subtitle
        friendCountLabel.font = .p2SubtitleEng
        friendSubTitleLabel.font = .p2Subtitle
        [checkTitleLabel, goalTitleLabel, friendTitleLabel].forEach {$0.font = .h2Title}
        [photoLabel, stopwatchLabel, timeLabel, goalLabel].forEach {$0.font = .p1TitleLight}
        
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
    
    func setData() {
        if let member = dummydata["members"] {
            memberList = member as! [Any]
        }
    }
    
    func setAddTarget() {
        copyButton.addTarget(self, action: #selector(copyToClipboard), for: .touchUpInside)
    }
    
    func setCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WaitingFriendCVC.self, forCellWithReuseIdentifier: WaitingFriendCVC.identifier)
        
        collectionViewFlowLayout.scrollDirection = .horizontal
    }
    
    @objc
    func copyToClipboard() {
        UIPasteboard.general.string = dummydata["roomCode"]! as! String
    }
}

extension WaitingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitingFriendCVC.identifier, for: indexPath) as? WaitingFriendCVC else { return UICollectionViewCell() }
        // FIXME: - 강제언래핑 제거
        let member: Dictionary<String, Any> = memberList[indexPath.item] as! Dictionary<String, Any>
        cell.nameLabel.text = "\(String(describing: member["nickname"]!))"
        return cell
    }
}

extension WaitingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}

extension WaitingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

// MARK: - Layout
extension WaitingVC {
    func setLayout() {
        view.addSubviews([copyButton, checkTitleLabel, toolTipButton,
                         stopwatchLabel, checkDivideView, photoLabel,
                          firstDivideLabel, goalTitleLabel, profileImageView,
                          nicknameLabel, timeLabel, goalLabel, editButton,
                         secondDivideLabel, friendTitleLabel, friendCountLabel,
                          friendSubTitleLabel, refreshButton, collectionView, startButton])
        
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
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(friendSubTitleLabel.snp.bottom).offset(24)
            make.height.equalTo(85)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(54)
            make.height.equalTo(48)
        }
    }
}
