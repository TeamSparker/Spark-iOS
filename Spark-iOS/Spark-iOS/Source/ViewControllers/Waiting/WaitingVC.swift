//
//  WaitingVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//

import UIKit

import SnapKit
import SwiftUI

class WaitingVC: UIViewController {
    var members: [Member] = []
    var isFromHome: Bool?
    
    // MARK: - Properties
    
    let copyButton = UIButton()
    let checkTitleLabel = UILabel()
    let toolTipButton = UIButton()
    let stopwatchLabel = UILabel()
    let checkDivideView = UIView()
    let photoLabel = UILabel()
    let firstDivideView = UIView()
    
    let goalTitleLabel = UILabel()
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let timeLabel = UILabel()
    let goalLabel = UILabel()
    let editButton = UIButton()
    let secondDivideView = UIView()
    
    let friendTitleLabel = UILabel()
    let friendCountLabel = UILabel()
    let friendSubTitleLabel = UILabel()
    let refreshButton = UIButton()
    let startButton = UIButton()
    
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    var memberList: [Any] = []
    var photoOnly: Bool? /// 사진 인증만
    var roomName: String?
    var roomCode: String?
    var roomId: Int?
    var userMoment: String?
    var userPurpose: String?
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setCollectionView()
        setAddTarget()
        setAuthLabel()
        setNavigation(title: roomName ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getWaitingRoomWithAPI(roomID: roomId ?? 0)
//        getWaitingRoomWithAPI(roomID: 235)
    }

    // MARK: - Methods
    func setNavigation(title: String) {
        if isFromHome ?? false {
            navigationController?.initWithTwoCustomButtonsTitle(navigationItem: self.navigationItem,
                                                                title: "\(title)",
                                                                tintColor: .sparkBlack,
                                                                backgroundColor: .sparkWhite,
                                                                reftButtonImage: UIImage(named: "icBackWhite"),
                                                                rightButtonImage: UIImage(),
                                                                reftButtonSelector: #selector(goToHomeVC),
                                                                rightButtonSelector: #selector(touchToMore))
        } else {
            navigationController?.initWithTwoCustomButtonsTitle(navigationItem: self.navigationItem,
                                                                title: "\(title)",
                                                                tintColor: .sparkBlack,
                                                                backgroundColor: .sparkWhite,
                                                                reftButtonImage: UIImage(named: "icHome"),
                                                                rightButtonImage: UIImage(),
                                                                reftButtonSelector: #selector(goToHomeVC),
                                                                rightButtonSelector: #selector(touchToMore))
        }
    }
    
    func setUI() {
        profileImageView.backgroundColor = .sparkLightGray
        firstDivideView.backgroundColor = .sparkDarkGray.withAlphaComponent(0.5)
        secondDivideView.backgroundColor = .sparkDarkGray.withAlphaComponent(0.5)
        checkDivideView.backgroundColor = .sparkDarkGray
        
        copyButton.setImage(UIImage(named: "btnSmall"), for: .normal)
        toolTipButton.setImage(UIImage(named: "icInformation"), for: .normal)
        editButton.setImage(UIImage(named: "btnEdit"), for: .normal)
        refreshButton.setImage(UIImage(named: "btnRefresh"), for: .normal)
        
        copyButton.isHighlighted = false
        toolTipButton.isHighlighted = false
        editButton.isHighlighted = false
        refreshButton.isHighlighted = false
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.cornerRadius = 32
        profileImageView.contentMode = .scaleAspectFill
        
        checkTitleLabel.text = "습관 인증 방식"
        photoLabel.text = "사진 인증"
        stopwatchLabel.text = "스톱워치"
        goalTitleLabel.text = "나의 목표"
        nicknameLabel.text = "힛이"
        friendTitleLabel.text = "함께하는 스파커들"
        friendSubTitleLabel.text = "습관을 시작한 후에는 인원 추가가 불가능합니다."
        
        nicknameLabel.font = .h3Subtitle
        friendCountLabel.font = .p2SubtitleEng
        friendSubTitleLabel.font = .p2Subtitle
        [checkTitleLabel, goalTitleLabel, friendTitleLabel].forEach {$0.font = .h2Title}
        [photoLabel, stopwatchLabel, timeLabel, goalLabel].forEach {$0.font = .p1TitleLight}
        
        [checkTitleLabel, goalTitleLabel, friendTitleLabel,
         nicknameLabel, friendCountLabel, timeLabel, goalLabel].forEach {
            $0.textColor = .sparkDeepGray
        }
        
        [photoLabel, stopwatchLabel].forEach {
            $0.textColor = .sparkDarkGray
        }
        
        friendSubTitleLabel.textColor = .gray
        
        startButton.layer.cornerRadius = 2
        startButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        startButton.setTitle("습관방 만들기", for: .normal)
        startButton.backgroundColor = .sparkPinkred
    }
    
    /// 선택한 인증 방식
    func setAuthLabel() {
        if photoOnly ?? true {
            [stopwatchLabel, checkDivideView].forEach { $0.isHidden = true }
        } else {
            [stopwatchLabel, checkDivideView].forEach { $0.isHidden = false }
        }
    }
    
    func setAddTarget() {
        copyButton.addTarget(self, action: #selector(copyToClipboard), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(touchEditButton), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(touchToRefreshButton), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(touchToCreateButton), for: .touchUpInside)
    }
    
    func setCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WaitingFriendCVC.self, forCellWithReuseIdentifier: WaitingFriendCVC.identifier)
        
        collectionViewFlowLayout.scrollDirection = .horizontal
    }
    
    func refreshButtonAnimtation() {
        UIView.animate(withDuration: 0.4,
                       delay: 0.1,
                       options: .curveEaseInOut) {
            let rotate = CGAffineTransform(rotationAngle: .pi)
            self.refreshButton.transform = rotate
        } completion: { _ in
            self.refreshButton.transform = .identity
        }
    }
    
    @objc
    func copyToClipboard() {
        UIPasteboard.general.string = roomCode
        showToast(x: 20, y: startButton.frame.minY - 60, message: "코드를 복사했어요", font: .p1TitleLight)
    }
    
    @objc
    func touchEditButton() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.goalWriting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.goalWriting) as? GoalWritingVC else { return }
        
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.titleText = roomName
        nextVC.roomId = roomId
        nextVC.moment = userMoment
        nextVC.purpose = userPurpose
        
        present(nextVC, animated: true, completion: nil)
    }
    
    // MARK: - 화면 전환
    
    @objc
    func goToHomeVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func touchToMore() {
        // 더보기 버튼
    }
    
    @objc
    func touchToRefreshButton() {
        refreshButtonAnimtation()
        getWaitingMembersWithAPI(roomID: roomId ?? 0)
    }
    
    @objc
    func touchToCreateButton() {
        postStartRoomWithAPI(roomID: roomId ?? 0)
        // TODO: - 상세뷰로 화면 전환
    }
}

// MARK: - Network

extension WaitingVC {
    func getWaitingRoomWithAPI(roomID: Int) {
        RoomAPI.shared.waitingFetch(roomID: roomID) { response in
            switch response {
            case .success(let data):
                if let waitingRoom = data as? Waiting {
                    var user: ReqUser
                    
                    user = waitingRoom.reqUser
                    self.members.append(contentsOf: waitingRoom.members)
                    
                    // 스파커 멤버 수
                    self.friendCountLabel.text = "\(self.members.count)"
                    
                    // 인증 방식
                    if waitingRoom.fromStart {
                        [self.stopwatchLabel, self.checkDivideView].forEach { $0.isHidden = false }
                    } else {
                        [self.stopwatchLabel, self.checkDivideView].forEach { $0.isHidden = true }
                    }
                    
                    // 방 코드
                    self.roomCode = waitingRoom.roomCode
                    
                    // 방 이름
                    self.roomName = waitingRoom.roomName
                    
                    // 사용자 본인 이름
                    self.nicknameLabel.text = user.nickname
                    
                    // 사용자 목표, 시간
                    self.userPurpose = user.purpose
                    self.userMoment = user.moment
                    
                    // 본인 방장 여부
                    if user.isHost {
                        self.startButton.isHidden = false
                    } else {
                        self.startButton.isHidden = true
                    }
                    
                    // 목표가 있을 경우, 목표와 시간 세팅
                    if user.isPurposeSet {
                        self.timeLabel.text = "시간  \(String(describing: user.moment!))"
                        self.goalLabel.text = "목표  \(String(describing: user.purpose!))"
                        self.timeLabel.partFontChange(targetString: "시간", font: .p1Title)
                        self.goalLabel.partFontChange(targetString: "목표", font: .p1Title)
                    } else {
                        // 엠티라벨
                        self.timeLabel.text = "습관을 시작하기 전에"
                        self.goalLabel.text = "시간과 목표를 작성해 주세요!"
                    }
                    
                    // 사용자 이미지 설정
                    if user.profileImg != nil {
                        if let url = URL(string: user.profileImg ?? "") {
                            do {
                                let data = try Data(contentsOf: url)
                                self.profileImageView.image = UIImage(data: data)
                            } catch {
                                self.profileImageView.image = UIImage(named: "profileEmpty")
                                self.profileImageView.backgroundColor = .sparkGray
                            }
                        }
                    } else {
                        self.profileImageView.image = UIImage(named: "profileEmpty")
                        self.profileImageView.backgroundColor = .sparkGray
                    }
                    self.collectionView.reloadData()
                }
            case .requestErr(let message):
                print("getWaitingRoomWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getWaitingRoomWithAPI - pathErr")
            case .serverErr:
                print("getWaitingRoomWithAPI - serverErr")
            case .networkFail:
                print("getWaitingRoomWithAPI - networkFail")
            }
        }
    }
    
    func getWaitingMembersWithAPI(roomID: Int) {
        RoomAPI.shared.waitingMemberFetch(roomID: roomID) { response in
            switch response {
            case .success(let data):
                if let waitingMembers = data as? WaitingMember {
                    
                    // 기존 스파커 삭제 & 다시 데이터 추가
                    self.members.removeAll()
                    self.members.append(contentsOf: waitingMembers.members)
                    
                    // 스파커 멤버 수
                    self.friendCountLabel.text = "\(self.members.count)"
                    
                    self.collectionView.reloadData()
                }
            case .requestErr(let message):
                print("getWaitingMembersWithAPI - requestErr", message)
            case .pathErr:
                print("getWaitingMembersWithAPI - pathErr")
            case .serverErr:
                print("getWaitingMembersWithAPI - serverErr")
            case .networkFail:
                print("getWaitingMembersWithAPI - networkFail")
            }
        }
    }
    
    func postStartRoomWithAPI(roomID: Int) {
        RoomAPI.shared.startRoomWithAPI(roomID: roomID) { response in
            switch response {
            case .success(let message):
                print("postStartRoomWithAPI - success: \(message)")
            case .requestErr(let message):
                print("postStartRoomWithAPI - requestErr: \(message)")
            case .pathErr:
                print("postStartRoomWithAPI - pathErr")
            case .serverErr:
                print("postStartRoomWithAPI - serverErr")
            case .networkFail:
                print("postStartRoomWithAPI - networkFail")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension WaitingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitingFriendCVC.identifier, for: indexPath) as? WaitingFriendCVC else { return UICollectionViewCell() }

        // 이름
        let name = members[indexPath.item].nickname
        cell.nameLabel.text = name
        
        // 이미지
        if let url = URL(string: members[indexPath.item].profileImg ?? "") {
            do {
                let data = try Data(contentsOf: url)
                // FIXME: - 서버에서 디폴트 이미지도 보내준다고 하셨는데 지금은 nil 값으로 넘어와서 나중에 수정해서 initCell 사용
//                cell.initCell(name: name, image: data)
                cell.profileImageView.image = UIImage(data: data)
            } catch {
                cell.profileImageView.backgroundColor = .sparkGray
            }
        } else {
            cell.profileImageView.image = UIImage(named: "profileEmpty")
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension WaitingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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
                          firstDivideView, goalTitleLabel, profileImageView,
                          nicknameLabel, timeLabel, goalLabel, editButton,
                          secondDivideView, friendTitleLabel, friendCountLabel,
                          friendSubTitleLabel, refreshButton, collectionView, startButton])
        
        copyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
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
        
        firstDivideView.snp.makeConstraints { make in
            make.top.equalTo(checkTitleLabel.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        goalTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(firstDivideView.snp.bottom).offset(33)
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
        
        secondDivideView.snp.makeConstraints { make in
            make.top.equalTo(goalLabel.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        friendTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(secondDivideView.snp.bottom).offset(32)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(self.view.frame.width*48/335)
        }
    }
}
