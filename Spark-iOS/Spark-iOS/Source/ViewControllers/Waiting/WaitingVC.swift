//
//  WaitingVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//

import UIKit

import SnapKit
import Lottie

/// 대기방을 접근하는 플로우를 알려주는 상태.
/// - fromHome : 홈에서 대기방 올 때.
/// - joinCode : 코드로 참여할 때.
/// - makeRoom : 방만들기로 대기방 올 때.

@frozen
enum FromWhereStatus {
    case fromHome
    case joinCode
    case makeRoom
}

class WaitingVC: UIViewController {
    
    // MARK: - Properties
    
    private let copyButton = UIButton()
    private let checkTitleLabel = UILabel()
    private let toolTipButton = UIButton()
    private let toolTipImageView = UIImageView()
    private let stopwatchLabel = UILabel()
    private let checkDivideView = UIView()
    private let photoLabel = UILabel()
    private let firstDivideView = UIView()
    
    private let goalTitleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let timeLabel = UILabel()
    private let goalLabel = UILabel()
    private let editButton = UIButton()
    private let secondDivideView = UIView()
    
    private let friendTitleLabel = UILabel()
    private let friendCountLabel = UILabel()
    private let friendSubTitleLabel = UILabel()
    private let refreshButton = UIButton()
    private let startButton = BottomButton().setTitle("습관 시작하기")
    
    private let tapGestrueRecognizer = UITapGestureRecognizer()
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    lazy var loadingBgView = UIView()
    lazy var loadingView = AnimationView(name: Const.Lottie.Name.loading)
    
    private var members: [Member] = []
    private var memberList: [Any] = []
    
    var photoOnly: Bool?
    var roomName: String?
    var roomCode: String?
    var roomId: Int?
    var userMoment: String?
    var userPurpose: String?
    var fromWhereStatus: FromWhereStatus?
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setCollectionView()
        setAddTarget()
        setAuthLabel()
        setNavigation(title: roomName ?? "")
        setGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.setLoading()
        }
        
        DispatchQueue.main.async {
            self.getWaitingRoomWithAPI(roomID: self.roomId ?? 0)
        }
    }
}

// MARK: - Methods

extension WaitingVC {
    private func setNavigation(title: String) {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        switch fromWhereStatus {
        case .fromHome:
            navigationController?.initWithTwoCustomButtonsTitle(navigationItem: self.navigationItem,
                                                                title: "\(title)",
                                                                tintColor: .sparkBlack,
                                                                backgroundColor: .sparkWhite,
                                                                reftButtonImage: UIImage(named: "icBackWhite"),
                                                                rightButtonImage: UIImage(),
                                                                reftButtonSelector: #selector(popToHomeVC),
                                                                rightButtonSelector: #selector(touchToMore))
        case .joinCode:
            navigationController?.initWithTwoCustomButtonsTitle(navigationItem: self.navigationItem,
                                                                title: "\(title)",
                                                                tintColor: .sparkBlack,
                                                                backgroundColor: .sparkWhite,
                                                                reftButtonImage: UIImage(named: "icHome"),
                                                                rightButtonImage: UIImage(),
                                                                reftButtonSelector: #selector(dismissJoinCodeToHomeVC),
                                                                rightButtonSelector: #selector(touchToMore))
        case .makeRoom:
            navigationController?.initWithTwoCustomButtonsTitle(navigationItem: self.navigationItem,
                                                                title: "\(title)",
                                                                tintColor: .sparkBlack,
                                                                backgroundColor: .sparkWhite,
                                                                reftButtonImage: UIImage(named: "icHome"),
                                                                rightButtonImage: UIImage(),
                                                                reftButtonSelector: #selector(dismissToHomeVC),
                                                                rightButtonSelector: #selector(touchToMore))
        case .none:
            print("fromeWhereStatus 를 지정해주세요.")
        }
    }
    
    private func setUI() {
        tabBarController?.tabBar.isHidden = true
        // 플로팅버튼 내리기
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
        
        [firstDivideView, secondDivideView].forEach {$0.backgroundColor = .sparkLightGray}
        checkDivideView.backgroundColor = .sparkDarkGray
        
        toolTipImageView.layer.masksToBounds = true
        toolTipImageView.contentMode = .scaleAspectFill
        toolTipImageView.alpha = 0
        
        copyButton.setImage(UIImage(named: "btnSmall"), for: .normal)
        toolTipButton.setImage(UIImage(named: "icInformation"), for: .normal)
        editButton.setImage(UIImage(named: "btnEdit"), for: .normal)
        refreshButton.setImage(UIImage(named: "btnRefresh"), for: .normal)
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkLightGray.cgColor
        profileImageView.layer.cornerRadius = 32
        profileImageView.contentMode = .scaleAspectFill
        
        checkTitleLabel.text = "습관 인증 방식"
        photoLabel.text = "사진 인증"
        stopwatchLabel.text = "스톱워치"
        goalTitleLabel.text = "나의 목표"
        nicknameLabel.text = "-"
        friendTitleLabel.text = "함께하는 스파커들"
        friendSubTitleLabel.text = "습관을 시작한 후에는 인원 추가가 불가능합니다."
        timeLabel.text = "습관을 시작하기 전에"
        goalLabel.text = "시간과 목표를 작성해 주세요!"
        
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
        
        startButton.isHidden = true
    }
    
    /// 선택한 인증 방식에 따라 라벨을 보이는 함수
    private func setAuthLabel() {
        if photoOnly ?? true {
            [stopwatchLabel, checkDivideView].forEach { $0.isHidden = true }
        } else {
            [stopwatchLabel, checkDivideView].forEach { $0.isHidden = false }
        }
    }
    
    private func setLoading() {
        view.addSubview(loadingBgView)
        loadingBgView.addSubview(loadingView)
        
        loadingBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
        }
        
        loadingBgView.backgroundColor = .white.withAlphaComponent(0.8)
        loadingView.loopMode = .loop
        loadingView.contentMode = .scaleAspectFit
        loadingView.play()
    }
    
    private func setAddTarget() {
        copyButton.addTarget(self, action: #selector(copyToClipboard), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(touchEditButton), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(touchToRefreshButton), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(touchToStartButton), for: .touchUpInside)
        toolTipButton.addTarget(self, action: #selector(touchPresentToolTip), for: .touchUpInside)
        tapGestrueRecognizer.addTarget(self, action: #selector(quickDismissToolTip))
    }
    
    private func setCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WaitingFriendCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.waitingFriendCVC)
        
        collectionViewFlowLayout.scrollDirection = .horizontal
    }
    
    /// 초기 대기방 정보 세팅하는 함수
    private func setInitData(fromstart: Bool, roomcode: String, roomname: String, user: ReqUser) {
        // 스파커 멤버 수
        friendCountLabel.text = "\(self.members.count)"
        
        // 인증 방식
        if fromstart {
            [stopwatchLabel, checkDivideView].forEach { $0.isHidden = false }
            toolTipImageView.image = UIImage(named: "timerToolTip")
        } else {
            [stopwatchLabel, checkDivideView].forEach { $0.isHidden = true }
            toolTipImageView.image = UIImage(named: "photoToolTip")
        }

        // 방 코드, 이름
        roomCode = roomcode
        roomName = roomname

        // 사용자 본인 이름
        nicknameLabel.text = user.nickname

        // 사용자 목표, 시간
        userPurpose = user.purpose
        userMoment = user.moment

        // 본인 방장 여부
        if user.isHost {
            startButton.isHidden = false
        } else {
            startButton.isHidden = true
        }

        // 목표가 있을 경우, 목표와 시간 세팅
        if user.isPurposeSet {
            timeLabel.text = "시간  \(String(describing: user.moment!))"
            goalLabel.text = "목표  \(String(describing: user.purpose!))"
            timeLabel.partFontChange(targetString: "시간", font: .p1Title)
            goalLabel.partFontChange(targetString: "목표", font: .p1Title)
        } else {
            timeLabel.text = "습관을 시작하기 전에"
            goalLabel.text = "시간과 목표를 작성해 주세요!"
        }

        // 사용자 이미지 설정
        profileImageView.updateImage(user.profileImg)
        collectionView.reloadData()
    }
    
    /// 대기방 멤버 갱신하는 함수
    private func setMemberData() {
        friendCountLabel.text = "\(self.members.count)"
        collectionView.reloadData()
    }
    
    private func stopLoadingAnimation() {
        loadingView.stop()
        loadingBgView.removeFromSuperview()
    }
    
    private func refreshButtonAnimtation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            let firstRotate = CGAffineTransform(rotationAngle: -3.14)
            self.refreshButton.transform = firstRotate
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: .curveEaseOut,
                           animations: {
                let secondRotate = CGAffineTransform(rotationAngle: -(3.14*2.0))
                self.refreshButton.transform = secondRotate
            },
                           completion: { _ in
                self.refreshButton.transform = .identity
            })
        })
    }
    
    private func presentToolTip() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.toolTipImageView.transform = CGAffineTransform.identity
            self.toolTipImageView.alpha = 1
        },
                       completion: nil)
    }
    
    private func dismissToolTip() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.toolTipImageView.transform = CGAffineTransform.identity
            self.toolTipImageView.alpha = 0
        },
                       completion: nil)
    }
    
    private func setGestureRecognizer() {
        tapGestrueRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestrueRecognizer)
    }
    
    // MARK: - @objc
    
    @objc
    private func copyToClipboard() {
        UIPasteboard.general.string = roomCode
        showToast(x: 20, y: view.safeAreaInsets.top, message: "코드를 복사했어요!", font: .p1TitleLight)
    }
    
    @objc
    private func touchEditButton() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.goalWriting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.goalWriting) as? GoalWritingVC else { return }
        
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.titleText = roomName
        nextVC.roomId = roomId
        nextVC.moment = userMoment
        nextVC.purpose = userPurpose
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc
    private func quickDismissToolTip() {
        toolTipImageView.alpha = 0
    }
    
    @objc
    private func touchPresentToolTip() {
        presentToolTip()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) { [self] in
            dismissToolTip()
        }
    }
    
    @objc
    private func popToHomeVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func dismissToHomeVC() {
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @objc
    private func dismissJoinCodeToHomeVC() {
        presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
        NotificationCenter.default.post(name: .appearFloatingButton, object: nil)
    }
    
    @objc
    private func touchToMore() {
        
        // TODO: - 더보기 버튼
        
    }
    
    @objc
    private func touchToRefreshButton() {
        refreshButtonAnimtation()
        getWaitingMembersWithAPI(roomID: roomId ?? 0)
    }
    
    @objc
    private func touchToStartButton() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.roomStart, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.roomStart) as? RoomStartVC else { return }
        
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        
        self.present(nextVC, animated: true, completion: nil)
        
//        DispatchQueue.main.async {
//            self.setLoading()
//        }
//
//        DispatchQueue.main.async {
//            self.postStartRoomWithAPI(roomID: self.roomId ?? 0) {
//                switch self.fromWhereStatus {
//                case .fromHome:
//                    self.popToHomeVC()
//                case .makeRoom:
//                    self.dismissToHomeVC()
//                case .joinCode:
//                    // 코드로 참여시에는 createButton 이 히든되어 있어서 아무런 동작이 필요하지 않다.
//                    return
//                case .none:
//                    print("fromeWhereStatus 를 지정해주세요.")
//                }
//            }
//        }
    }
}

// MARK: - Network

extension WaitingVC {
    private func getWaitingRoomWithAPI(roomID: Int) {
        RoomAPI.shared.waitingFetch(roomID: roomID) { response in
            switch response {
            case .success(let data):
                self.stopLoadingAnimation()
                if let waitingRoom = data as? Waiting {
                    let user: ReqUser = waitingRoom.reqUser
                    self.members = waitingRoom.members
                    self.setInitData(fromstart: waitingRoom.fromStart, roomcode: waitingRoom.roomCode, roomname: waitingRoom.roomName, user: user)
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
    
    private func getWaitingMembersWithAPI(roomID: Int) {
        RoomAPI.shared.waitingMemberFetch(roomID: roomID) { response in
            switch response {
            case .success(let data):
                if let waitingMembers = data as? WaitingMember {
                    self.members = waitingMembers.members
                    self.setMemberData()
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
    
    private func postStartRoomWithAPI(roomID: Int, completion: @escaping () -> Void) {
        RoomAPI.shared.startRoomWithAPI(roomID: roomID) { response in
            switch response {
            case .success(let message):
                self.stopLoadingAnimation()
                completion()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.waitingFriendCVC, for: indexPath) as? WaitingFriendCVC else { return UICollectionViewCell() }
        
        let name = members[indexPath.item].nickname
        let imagePath = members[indexPath.item].profileImg ?? ""
        
        cell.initCell(name: name, imagePath: imagePath)
        
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
                          friendSubTitleLabel, refreshButton, collectionView, startButton, toolTipImageView])
        
        copyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(6)
            make.width.equalTo(87)
            make.height.equalTo(36)
        }
        
        checkTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(copyButton.snp.bottom).offset(UIScreen.main.hasNotch ? 40 : 24)
        }
        
        toolTipButton.snp.makeConstraints { make in
            make.leading.equalTo(checkTitleLabel.snp.trailing).offset(4)
            make.centerY.equalTo(checkTitleLabel.snp.centerY).offset(2)
            make.width.height.equalTo(24)
        }
        
        toolTipImageView.snp.makeConstraints { make in
            make.centerX.equalTo(toolTipButton.snp.centerX).offset(-0.5)
            make.top.equalTo(toolTipButton.snp.bottom).offset(3)
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
            make.top.equalTo(checkTitleLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 36 : 24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        goalTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(firstDivideView.snp.bottom).offset(UIScreen.main.hasNotch ? 33 : 24)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(goalTitleLabel.snp.centerY)
            make.width.height.equalTo(44)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(goalTitleLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 36 : 20)
            make.width.height.equalTo(64)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(-12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 15 : 10)
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.trailing.equalToSuperview().inset(20)
        }
        
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(4)
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.trailing.equalToSuperview().inset(20)
        }
        
        secondDivideView.snp.makeConstraints { make in
            make.top.equalTo(goalLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 45 : 30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        friendTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(secondDivideView.snp.bottom).offset(UIScreen.main.hasNotch ? 33 : 24)
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
            make.top.equalTo(friendSubTitleLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 24 : 20)
            make.height.equalTo(85)
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
// FIXME: - 네비게이션 extension 정리후 공통으로 빼서 사용하기
extension WaitingVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
