//
//  HabitRoomVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/19.
//

import UIKit

class HabitRoomVC: UIViewController {
    
    // MARK: - Properties

    var roomName: String?
    var roomID: Int?
    var habitRoomDetail: HabitRoomDetail?
    
    private let picker = UIImagePickerController()
    private var imageContainer = UIImage()
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var flakeImageView: UIImageView!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var ddayTitleLabel: UILabel!
    @IBOutlet weak var progessView: UIProgressView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var firstLifeImage: UIImageView!
    @IBOutlet weak var secondLifeImage: UIImageView!
    @IBOutlet weak var thirdLifeImage: UIImageView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var authButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setDelegate()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchHabitRoomDetailWithAPI(roomID: roomID ?? 0) {
            self.mainCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    // FIXME: - update??
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        guard let habitRoomDetail = habitRoomDetail else { return }
//        setUIByData(habitRoomDetail)
//    }
    
    // MARK: - @IBOutlet Action
    
    @IBAction func popToHomeVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func presentToHabitAuthVC(_ sender: Any) {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.habitAuth, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.habitAuth) as? HabitAuthVC else { return }
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.roomID = roomID
        nextVC.roomName = roomName
        nextVC.restNumber = habitRoomDetail?.myRecord.rest
        nextVC.restStatus = habitRoomDetail?.myRecord.status
        nextVC.presentAlertClosure = {
            self.showAlert()
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
        navigationController?.isNavigationBarHidden = true
    
        tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
        
        habitTitleLabel.font = .h3Subtitle
        habitTitleLabel.textColor = .sparkWhite
        
        flakeImageView.contentMode = .scaleToFill
        
        ddayTitleLabel.font = .h1BigtitleEng
        ddayTitleLabel.textColor = .sparkWhite
        
        progessView.trackTintColor = .sparkDeepGray
        
        startDateLabel.font = .captionEng
        startDateLabel.textColor = .sparkWhite
        
        endDateLabel.font = .captionEng
        endDateLabel.textColor = .sparkWhite
        
        bgView.layer.borderColor = UIColor.sparkDarkGray.cgColor
        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 2
        
        timeLabel.font = .p2Subtitle
        goalLabel.font = .p2Subtitle
        
        moreButton.isHidden = true
        
        authButton.setTitle("오늘의 인증", for: .normal)
        authButton.setTitleColor(.sparkWhite, for: .normal)
        authButton.titleLabel?.font = .btn1Default
        authButton.backgroundColor = .sparkDarkPinkred
        authButton.layer.cornerRadius = 2
        authButton.layer.shadowColor = UIColor.sparkDarkPinkred.cgColor
        authButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        authButton.layer.shadowOpacity = Float(0.3)
        authButton.layer.shadowRadius = 10
    }
    
    private func setUIByData(_ habitRoomDetail: HabitRoomDetail) {
        roomName = habitRoomDetail.roomName
        habitTitleLabel.text = habitRoomDetail.roomName

        let leftDay = habitRoomDetail.leftDay
        
        if leftDay == 0 {
            ddayTitleLabel.text = "D-day"
        } else {
            ddayTitleLabel.text = "D-\(leftDay)"
        }
        
        let sparkFlake = SparkFlake(leftDay: leftDay)
        flakeImageView.image = sparkFlake.sparkFlakeHabitBackground()
        progessView.progressTintColor = sparkFlake.sparkFlakeColor()
        // 맞나..?
        progessView.setProgress(Float((66 - leftDay )/66), animated: true)
        
        startDateLabel.text = habitRoomDetail.startDate
        endDateLabel.text = habitRoomDetail.endDate
        
        timeLabel.text = habitRoomDetail.moment
        goalLabel.text = habitRoomDetail.purpose
        
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
    }
    
    private func setDelegate() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        picker.delegate = self
    }
    
    private func registerXib() {
        mainCollectionView.register(UINib(nibName: Const.Xib.NibName.habitRoomMemeberCVC, bundle: nil), forCellWithReuseIdentifier: Const.Xib.NibName.habitRoomMemeberCVC)
    }

    func showAlert() {
        let alter = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alter.view.tintColor = .sparkBlack

        /// alter에 들어갈 액션 생성
        let camera = UIAlertAction(title: "카메라 촬영", style: .default) { _ in
            self.openCamera()
        }
        let library = UIAlertAction(title: "앨범에서 선택하기", style: .default) { _ in
            self.openLibrary()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        /// alter에 액션을 넣어줌
        alter.addAction(camera)
        alter.addAction(library)
        alter.addAction(cancel)

        present(alter, animated: true, completion: nil)
    }

    private func openLibrary() {
        /// UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 앨범에서 픽해오겠다
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    private func openCamera() {
        /// 카메라 촬영 타입이 가능하다면
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            /// UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 카메라 촬영헤서 픽해오겠다
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            print("카메라 안됩니다.")
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
        nextVC.uploadImageView.image = self.imageContainer.resize(newWidth: UIScreen.main.bounds.width*nextVC.resizeRatio)
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
        return 1 + (habitRoomDetail?.otherRecords.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.NibName.habitRoomMemeberCVC, for: indexPath) as? HabitRoomMemberCVC else { return UICollectionViewCell() }
        if indexPath.item == 0 {
            cell.initCellMe(recordID: habitRoomDetail?.myRecord.recordID ?? 0,
                            userID: habitRoomDetail?.myRecord.userID ?? 0,
                            profileImg: habitRoomDetail?.myRecord.profileImg ?? "",
                            nickname: habitRoomDetail?.myRecord.nickname ?? "",
                            status: habitRoomDetail?.myRecord.status ?? "",
                            receivedSpark: habitRoomDetail?.myRecord.receivedSpark ?? 0)
            
            return cell
        } else {
            cell.initCellOthers(recordID: habitRoomDetail?.otherRecords[indexPath.item - 1]?.recordID ?? 0,
                                userID: habitRoomDetail?.otherRecords[indexPath.item - 1]?.userID ?? 0,
                                profileImg: habitRoomDetail?.otherRecords[indexPath.item - 1]?.profileImg ?? "",
                                nickname: habitRoomDetail?.otherRecords[indexPath.item - 1]?.nickname ?? "",
                                status: habitRoomDetail?.otherRecords[indexPath.item - 1]?.status ?? "",
                                sparkDone: false)
            
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
    private func fetchHabitRoomDetailWithAPI(roomID: Int, completion: @escaping () -> Void) {
        RoomAPI.shared.fetchHabitRoomDetail(roomID: roomID) { response in
            switch response {
            case .success(let data):
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
}
