//
//  HabitRoomVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/19.
//

import UIKit

import FirebaseAnalytics
import Lottie

class HabitRoomVC: UIViewController {
    
    // MARK: - Properties

    var roomName: String?
    var roomID: Int?
    var habitRoomDetail: HabitRoomDetail?
    
    private let picker = UIImagePickerController()
    private var imageContainer = UIImage()
    
    private lazy var loadingBgView = UIView()
    private lazy var loadingView = AnimationView(name: Const.Lottie.Name.loading)
    lazy var refreshControl = UIRefreshControl()
    
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var customNavigationBar: LeftRightButtonsNavigationBar!
    @IBOutlet weak var goalTextField: UILabel!
    @IBOutlet weak var timeTextLabel: UILabel!
    @IBOutlet weak var flakeImageView: UIImageView!
    @IBOutlet weak var ddayTitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var firstLifeImage: UIImageView!
    @IBOutlet weak var secondLifeImage: UIImageView!
    @IBOutlet weak var thirdLifeImage: UIImageView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var gradationView: UIView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setDelegate()
        registerXib()
        setNotification()
        initRefreshControl()
        tracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateHabitRoom()
        setTabBar()
        setFloatingButton()
    }
    
    // set status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - @IBOutlet Action
    
    @IBAction func presentToHabitAuthVC(_ sender: Any) {
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackGenerator?.impactOccurred()
        impactFeedbackGenerator = nil
        
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.habitAuth, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.habitAuth) as? HabitAuthVC else { return }
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.roomID = roomID
        nextVC.roomName = roomName
        nextVC.restNumber = habitRoomDetail?.myRecord.rest
        nextVC.restStatus = habitRoomDetail?.myRecord.status
        nextVC.presentAlertClosure = {
            self.showAuthAlert()
        }
        
        if let fromStart = habitRoomDetail?.fromStart {
            if fromStart {
                nextVC.authType = .photoTimer
            } else {
                nextVC.authType = .photoOnly
            }
        }
        
        present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - Methods

extension HabitRoomVC {
    private func setUI() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        customNavigationBar
            .tintColor(.sparkWhite)
            .backgroundColor(.clear)
            .leftButtonImage("icBackWhite")
            .leftButtonAction {
                self.popToHomeVC()
            }
            .rightButtonImage("icMoreVerticalWhite")
            .rightButtonAction {
                self.presentToMoreAlert()
            }
        
        flakeImageView.contentMode = .scaleAspectFit
        
        progressView.setProgress(0, animated: false)
        progressView.trackTintColor = .sparkDeepGray
        
        ddayTitleLabel.font = .h1BigtitleEng
        ddayTitleLabel.textColor = .sparkWhite
        ddayTitleLabel.text = ""
        
        startDateLabel.font = .captionEng
        startDateLabel.textColor = .sparkWhite
        startDateLabel.text = ""
        
        endDateLabel.font = .captionEng
        endDateLabel.textColor = .sparkWhite
        endDateLabel.text = ""
        
        bgView.layer.borderColor = UIColor.sparkDarkGray.cgColor
        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 2
        
        timeLabel.font = .p2Subtitle
        timeLabel.text = ""
        goalLabel.font = .p2Subtitle
        goalLabel.text = ""
        
        authButton.setTitle("오늘의 인증", for: .normal)
        authButton.setTitleColor(.sparkWhite, for: .normal)
        authButton.titleLabel?.font = .btn1Default
        authButton.backgroundColor = .sparkGray
        authButton.isEnabled = false
        
        gradationView.setHabitGradient()
    }
    
    private func setTabBar() {
        guard let tabBarController = tabBarController as? SparkTabBarController else { return }
        tabBarController.sparkTabBar.isHidden = true
    }
    
    private func setFloatingButton() {
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
    }
    
    private func setUIByData(_ habitRoomDetail: HabitRoomDetail) {
        customNavigationBar.title(habitRoomDetail.roomName)
        roomName = habitRoomDetail.roomName

        let leftDay = habitRoomDetail.leftDay
        
        if leftDay == 0 {
            ddayTitleLabel.text = "D-day"
        } else {
            ddayTitleLabel.text = "D-\(leftDay)"
        }
        
        let sparkFlake = SparkFlake(leftDay: leftDay)
        flakeImageView.image = sparkFlake.sparkFlakeHabitBackground()
        progressView.progressTintColor = sparkFlake.sparkFlakeColor()
        
        progressView.setProgress(Float(66 - leftDay) / Float(66), animated: true)
        
        startDateLabel.text = habitRoomDetail.startDate
        endDateLabel.text = habitRoomDetail.endDate
        
        if habitRoomDetail.moment != nil {
            timeTextLabel.text = "시간"
            timeLabel.text = habitRoomDetail.moment
        } else {
            timeTextLabel.text = ""
            timeLabel.text = "아직 구체적인 계획이 없어요."
        }
        
        if habitRoomDetail.purpose != nil {
            goalTextField.text = "목표"
            goalLabel.text = habitRoomDetail.purpose
        } else {
            goalTextField.text = ""
            goalLabel.text = "나만의 시간과 목표를 작성해 보세요!"
        }
        
        // 방 생명 이미지 구현
        let lifeImgaeList = [firstLifeImage, secondLifeImage, thirdLifeImage]
        let life = habitRoomDetail.life
        
        if life >= 3 {
            lifeImgaeList.forEach { $0?.image = UIImage(named: "icRoomlifeFullWhite")}
        } else if life == 0 {
            lifeImgaeList.forEach { $0?.image = UIImage(named: "icRoomlifeEmpty")}
        } else {
            for index in 0..<life {
                lifeImgaeList[index]?.image = UIImage(named: "icRoomlifeFullWhite")
            }
            for index in life...2 {
                lifeImgaeList[index]?.image = UIImage(named: "icRoomlifeEmpty")
            }
        }
        
        // 오늘의 인증 버튼 세팅
        if leftDay == 66 {
            authButton.isEnabled = false
            authButton.backgroundColor = .sparkGray
            authButton.layer.borderWidth = 0
        } else {
            if habitRoomDetail.myRecord.status == "DONE" ||
               habitRoomDetail.myRecord.status == "REST" {
                authButton.isEnabled = false
                authButton.backgroundColor = .sparkGray
                authButton.layer.borderWidth = 0
                authButton.layer.shadowColor = UIColor.sparkWhite.cgColor
            } else {
                authButton.isEnabled = true
                authButton.backgroundColor = .sparkDarkPinkred
                authButton.layer.cornerRadius = 2
                authButton.layer.shadowColor = UIColor.sparkDarkPinkred.cgColor
                authButton.layer.shadowOffset = CGSize(width: 0, height: 2)
                authButton.layer.shadowOpacity = Float(0.3)
                authButton.layer.shadowRadius = 10
            }
        }
    }
    
    private func setLoading() {
        view.addSubview(loadingBgView)
        
        loadingBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingBgView.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
        }
        
        loadingBgView.backgroundColor = .white.withAlphaComponent(0.8)
        loadingView.loopMode = .loop
        loadingView.contentMode = .scaleAspectFit
        loadingView.play()
    }
    
    private func setHabitRoomGuide() {
        let checkedGuide = UserDefaults.standard.object(forKey: Const.UserDefaultsKey.checkHabitRoomGuide)
        
        if checkedGuide == nil {
            UserDefaults.standard.set(true, forKey: Const.UserDefaultsKey.checkHabitRoomGuide)
            guard let guideVC = UIStoryboard(name: Const.Storyboard.Name.habitRoomGuide, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.habitRoomGuide) as? HabitRoomGuideVC else { return }
            guideVC.dismissClousure = {
                self.setLifeDiminishDialogue()
            }
            guideVC.modalPresentationStyle = .overFullScreen
            guideVC.modalTransitionStyle = .crossDissolve
            
            self.present(guideVC, animated: true, completion: nil)
        } else {
            setLifeDiminishDialogue()
        }
    }
    
    private func setLifeDiminishDialogue() {
        if let lifeCount = habitRoomDetail?.lifeDeductionCount, lifeCount != 0 {
            guard let lifeVC = UIStoryboard(name: Const.Storyboard.Name.lifeDiminishDialogue, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.lifeDiminishDialogue) as? LifeDiminishDialogueVC else { return }
            lifeVC.diminishedLifeCount = lifeCount
            lifeVC.modalPresentationStyle = .overFullScreen
            lifeVC.modalTransitionStyle = .crossDissolve
            
            self.present(lifeVC, animated: true, completion: nil)
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateHabitRoom), name: .updateHabitRoom, object: nil)
    }
    
    private func setDelegate() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        picker.delegate = self
    }
    
    private func registerXib() {
        mainCollectionView.register(UINib(nibName: Const.Cell.Identifier.habitRoomMemeberCVC, bundle: nil), forCellWithReuseIdentifier: Const.Cell.Identifier.habitRoomMemeberCVC)
    }

    private func showAuthAlert() {
        let alert = SparkActionSheet()
        alert.addAction(SparkAction("카메라 촬영", titleType: .blackMediumTitle, handler: {
            alert.dismiss(animated: true) {
                self.openCamera()
            }
        }))
        
        alert.addAction(SparkAction("앨범에서 선택", titleType: .blackMediumTitle, handler: {
            alert.dismiss(animated: true) {
                self.openLibrary()
            }
        }))
        
        alert.addSection()
        
        alert.addAction(SparkAction("취소", titleType: .blackBoldTitle, handler: {
            alert.animatedDismiss(completion: nil)
        }))
        
        present(alert, animated: true)
    }

    private func openLibrary() {
        // UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 앨범에서 픽해오겠다
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    private func openCamera() {
        // 카메라 촬영 타입이 가능하다면
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 카메라 촬영헤서 픽해오겠다
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            print("카메라 안됩니다.")
        }
    }
    
    private func presentToSendSparkVC(recordID: Int, nickname: String, profileImage: String) {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.sendSpark, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.sendSpark) as? SendSparkVC else { return }
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.roomID = habitRoomDetail?.roomID
        nextVC.recordID = recordID
        nextVC.userName = nickname
        nextVC.profileImage = profileImage
        
        self.present(nextVC, animated: true, completion: nil)
    }
    
    private func initRefreshControl() {
        refreshControl.tintColor = .sparkPinkred
        refreshControl.addTarget(self, action: #selector(updateWithRefreshControl), for: .valueChanged)
        mainCollectionView.refreshControl = refreshControl
    }
    
    private func postNoti() {
        NotificationCenter.default.post(name: .leaveRoom, object: nil, userInfo: ["roomName": "\(roomName ?? "")", "waitingRoom": false])
    }
    
    private func presentToMoreAlert() {
        let alert = SparkActionSheet()
        alert.addAction(SparkAction("나의 목표 관리", titleType: .blackMediumTitle, handler: {
            self.dismiss(animated: true) {
                guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.goalWriting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.goalWriting) as? GoalWritingVC else { return }
                
                nextVC.modalPresentationStyle = .fullScreen
                nextVC.titleText = self.roomName
                nextVC.roomId = self.roomID
                nextVC.moment = self.habitRoomDetail?.moment
                nextVC.purpose = self.habitRoomDetail?.purpose
                
                self.present(nextVC, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(SparkAction("습관방 이용 팁", titleType: .blackMediumTitle, handler: {
            self.dismiss(animated: true) {
                guard let guideVC = UIStoryboard(name: Const.Storyboard.Name.habitRoomGuide, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.habitRoomGuide) as? HabitRoomGuideVC else { return }
                guideVC.modalPresentationStyle = .overFullScreen
                guideVC.modalTransitionStyle = .crossDissolve
                guideVC.fromMore = true
                
                self.present(guideVC, animated: true, completion: nil)
            }
        }))

        alert.addAction(SparkAction("방 나가기", titleType: .pinkMediumTitle, handler: {
            self.dismiss(animated: true) {
                guard let checkVC = UIStoryboard(name: Const.Storyboard.Name.habitRoomLeave, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.habitRoomLeave) as? HabitRoomLeaveVC else { return }
                
                checkVC.modalPresentationStyle = .overFullScreen
                checkVC.modalTransitionStyle = .crossDissolve
                checkVC.roomName = self.roomName ?? ""
                checkVC.closure = {
                    self.leaveHabitRoomWithAPI(roomID: self.roomID ?? 0)
                }
                
                self.present(checkVC, animated: true, completion: nil)
            }
        }))

        alert.addSection()

        alert.addAction(SparkAction("취소", titleType: .blackBoldTitle, handler: {
            alert.animatedDismiss(completion: nil)
        }))

        present(alert, animated: true)
    }
    
    private func tracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.View.viewHabitRoom
                           ])
    }
    
    // MARK: - Screen Change
    
    private func popToHomeVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func updateHabitRoom() {
        setLoading()
        fetchHabitRoomDetailWithAPI(roomID: self.roomID ?? 0) {
            self.mainCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            self.setHabitRoomGuide()
        }
    }
    
    @objc
    private func updateWithRefreshControl() {
        fetchHabitRoomDetailWithAPI(roomID: self.roomID ?? 0) {
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UIImagePickerDelegate
extension HabitRoomVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageContainer = image
        }
        
        dismiss(animated: true) {
            self.presentAuthUpload()
        }
    }

    private func presentAuthUpload() {
        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.authUpload, bundle: nil).instantiateViewController(identifier: Const.ViewController.Identifier.authUpload) as? AuthUploadVC else { return }

        nextVC.setFirstFlowUI()
        nextVC.roomId = self.roomID
        nextVC.roomName = self.roomName
        if let fromStart = habitRoomDetail?.fromStart {
            if fromStart {
                nextVC.vcType = .photoTimer
            } else {
                nextVC.vcType = .photoOnly
            }
        }
        nextVC.uploadImageView.image = self.imageContainer.resize()
        nextVC.modalPresentationStyle = .fullScreen
        
        self.present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension HabitRoomVC: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension HabitRoomVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let habitRoomDetail = habitRoomDetail {
            return 1 + (habitRoomDetail.otherRecords.count)
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.habitRoomMemeberCVC, for: indexPath) as? HabitRoomMemberCVC else { return UICollectionViewCell() }
        if indexPath.item == 0 {
            cell.initCellMe(recordID: habitRoomDetail?.myRecord.recordID ?? 0,
                            userID: habitRoomDetail?.myRecord.userID ?? 0,
                            profileImg: habitRoomDetail?.myRecord.profileImg ?? "",
                            nickname: habitRoomDetail?.myRecord.nickname ?? "",
                            status: habitRoomDetail?.myRecord.status ?? "",
                            receivedSpark: habitRoomDetail?.myRecord.receivedSpark ?? 0,
                            leftDay: habitRoomDetail?.leftDay ?? 0)
            
            return cell
        } else {
            cell.initCellOthers(recordID: habitRoomDetail?.otherRecords[indexPath.item - 1]?.recordID ?? 0,
                                userID: habitRoomDetail?.otherRecords[indexPath.item - 1]?.userID ?? 0,
                                profileImg: habitRoomDetail?.otherRecords[indexPath.item - 1]?.profileImg ?? "",
                                nickname: habitRoomDetail?.otherRecords[indexPath.item - 1]?.nickname ?? "",
                                status: habitRoomDetail?.otherRecords[indexPath.item - 1]?.status ?? "",
                                leftDay: habitRoomDetail?.leftDay ?? 0) { self.presentToSendSparkVC(recordID: self.habitRoomDetail?.otherRecords[indexPath.item - 1]?.recordID ?? 0, nickname: self.habitRoomDetail?.otherRecords[indexPath.item - 1]?.nickname ?? "", profileImage: self.habitRoomDetail?.otherRecords[indexPath.item - 1]?.profileImg ?? "") }
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HabitRoomVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let authButtonHeight = authButton.frame.height
        // safe area 와 버튼 
        return UIEdgeInsets(top: 13, left: 0, bottom: 33 + authButtonHeight, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        let cellHeight = cellWidth * (128 / 375)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - Network

extension HabitRoomVC {
    /// 습관방 데이터 불러오기
    private func fetchHabitRoomDetailWithAPI(roomID: Int, completion: @escaping () -> Void) {
        RoomAPI(viewController: self).fetchHabitRoomDetail(roomID: roomID) { response in
            switch response {
            case .success(let data):
                self.loadingView.stop()
                self.loadingBgView.removeFromSuperview()
                if let habitRoomDetail = data as? HabitRoomDetail {
                    self.setUIByData(habitRoomDetail)
                    self.habitRoomDetail = habitRoomDetail
                    self.mainCollectionView.reloadData()
                }
                
                completion()
            case .requestErr(let message):
                print("fetchHabitRoomDetailWithAPI - requestErr: \(message)")
            case .pathErr:
                print("fetchHabitRoomDetailWithAPI - pathErr")
            case .serverErr:
                print("fetchHabitRoomDetailWithAPI - serverErr")
            case .networkFail:
                print("fetchHabitRoomDetailWithAPI - networkFail")
            }
        }
    }
    
    /// 습관방 나가기
    private func leaveHabitRoomWithAPI(roomID: Int) {
        RoomAPI(viewController: self).leaveRoom(roomId: roomID) { response in
            switch response {
            case .success(let message):
                self.navigationController?.popViewController(animated: true)
                self.postNoti()
                print("deleteWaitingRoomWithAPI - success: \(message)")
            case .requestErr(let message):
                print("deleteWaitingRoomWithAPI - requestErr: \(message)")
            case .pathErr:
                print("deleteWaitingRoomWithAPI - pathErr")
            case .serverErr:
                print("deleteWaitingRoomWithAPI - serverErr")
            case .networkFail:
                print("deleteWaitingRoomWithAPI - networkFail")
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension HabitRoomVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
