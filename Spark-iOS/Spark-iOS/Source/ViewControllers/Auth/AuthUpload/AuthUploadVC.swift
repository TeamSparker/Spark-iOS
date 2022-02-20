//
//  AuthUploadVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/16.
//

import UIKit

import SnapKit
import Lottie

@frozen enum VCCase {
    case photoTimer
    case photoOnly
}

class AuthUploadVC: UIViewController {
    
    public var resizeRatio: CGFloat = 0.5
    
    // MARK: - Properties
    
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let fadeImageView = UIImageView()
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    private let stopwatchLabel = UILabel()
    private let photoLabel = UILabel()
    private let betweenLine = UIView()
    private let photoAuthButton = BottomButton().setTitle("사진 인증하기")
    private let picker = UIImagePickerController()
    private var buttonStackView = UIStackView()
    private var uploadButton = UIButton()
    private var changePhotoButton = UIButton()
    var uploadImageView = UIImageView()
    var timerLabel = UILabel()
    var roomId: Int?
    var roomName: String?
    var vcType: VCCase?
    
    private lazy var loadingBgView = UIView()
    private lazy var loadingView = AnimationView(name: Const.Lottie.Name.loading)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        setDelegate()
        setAddTarget()
    }
}

// MARK: - Methods

extension AuthUploadVC {
    private func setNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        
        switch vcType {
        case .photoOnly:
            navigationController?.initWithLeftButtonTitle(title: "\(String(describing: roomName))",
                                                          tintColor: .sparkBlack,
                                                          backgroundColor: .sparkWhite,
                                                          image: UIImage(named: "icQuit"),
                                                          selector: #selector(presentToDialogue))
        case .photoTimer:
            navigationController?.initWithTwoCustomButtonsTitle(navigationItem: self.navigationItem,
                                                                title: "icBackWhite",
                                                                tintColor: .sparkBlack,
                                                                backgroundColor: .sparkWhite,
                                                                reftButtonImage: UIImage(named: "icBackWhite")?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: 0.0)),
                                                                rightButtonImage: UIImage(named: "icQuit") ?? UIImage(),
                                                                reftButtonSelector: #selector(popToPresentingVC),
                                                                rightButtonSelector: #selector(showDialog))
            navigationItem.title = "\(roomName ?? "-")"
        default:
            break
        }
    }
    
    private func setUI() {
        closeButton.setImage(UIImage(named: "icQuit"), for: .normal)
        
        titleLabel.text = "\(roomName ?? "-")"
        firstLabel.text = "1"
        secondLabel.text = "2"
        stopwatchLabel.text = "스톱워치"
        photoLabel.text = "사진"
        
        titleLabel.textColor = .sparkBlack
        firstLabel.textColor = .sparkGray
        secondLabel.textColor = .sparkPinkred
        stopwatchLabel.textColor = .sparkGray
        photoLabel.textColor = .sparkPinkred
        
        titleLabel.font = .h3Subtitle
        firstLabel.font = .enMediumFont(ofSize: 18)
        secondLabel.font = .enMediumFont(ofSize: 18)
        stopwatchLabel.font = .krMediumFont(ofSize: 18)
        photoLabel.font = .krRegularFont(ofSize: 18)
        
        betweenLine.backgroundColor = .sparkPinkred
        
        fadeImageView.backgroundColor = .sparkBlack.withAlphaComponent(0.15)
        uploadImageView.contentMode = .scaleAspectFill
        uploadImageView.layer.masksToBounds = true
        
        setStackView()
        
        timerLabel.font = .enBoldFont(ofSize: 40)
        timerLabel.textColor = .sparkWhite
        timerLabel.isHidden = true
        
        changePhotoButton.layer.cornerRadius = 2
        changePhotoButton.titleLabel?.font = .btn1Default
        changePhotoButton.setTitle("사진 변경", for: .normal)
        changePhotoButton.backgroundColor = .sparkWhite
        changePhotoButton.tintColor = .sparkDarkPinkred
        changePhotoButton.setTitleColor(.sparkDarkPinkred, for: .normal)
        changePhotoButton.layer.borderWidth = 2
        changePhotoButton.layer.borderColor = .init(red: 1, green: 0, blue: 61/255, alpha: 1)
        changePhotoButton.isEnabled = true
        
        uploadButton.layer.cornerRadius = 2
        uploadButton.titleLabel?.font = .btn1Default
        uploadButton.setTitle("업로드하기", for: .normal)
        uploadButton.backgroundColor = .sparkDarkPinkred
        uploadButton.isEnabled = true
        
        switch vcType {
        case .photoOnly:
            setFirstFlowUI()
            
        case .photoTimer:
            setSecondFlowUI()
        default:
            break
        }
    }
    
    private func setDelegate() {
        picker.delegate = self
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
    
    private func setAddTarget() {
        closeButton.addTarget(self, action: #selector(dismissToHabitRoom), for: .touchUpInside)
        photoAuthButton.addTarget(self, action: #selector(touchAuthButton), for: .touchUpInside)
        changePhotoButton.addTarget(self, action: #selector(touchChangePhotoButton), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(touchUploadButton), for: .touchUpInside)
    }
    
    // 사진 인증만 하는 플로우 UI
    func setFirstFlowUI() {
        [firstLabel, secondLabel, stopwatchLabel,
         photoLabel, betweenLine, photoAuthButton, timerLabel].forEach { $0.isHidden = true }
        [uploadImageView, buttonStackView, fadeImageView, closeButton, titleLabel].forEach { $0.isHidden = false }
    }
    
    // 스톱워치 + 사진 인증하는 플로우 UI
    func setSecondFlowUI() {
        [firstLabel, secondLabel, stopwatchLabel,
         photoLabel, betweenLine, photoAuthButton].forEach { $0.isHidden = false }
        [buttonStackView, timerLabel, fadeImageView, closeButton, titleLabel].forEach { $0.isHidden = true }
        
        uploadImageView.image = UIImage(named: "uploadEmptyView")
    }
    
    private func setStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        buttonStackView.addArrangedSubview(changePhotoButton)
        buttonStackView.addArrangedSubview(uploadButton)
    }
    
    private func openLibrary() {
        // UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 앨범에서 픽해오겠다
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    private func openCamera() {
        // 카메라 촬영 타입이 가능하다면
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 카메라 촬영헤서 픽해오겠다
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            print("카메라 접근 안됨")
        }
    }
    
    private func showAlert() {
        let alter = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alter.view.tintColor = .sparkBlack
        
        // alter에 들어갈 액션 생성
        let library = UIAlertAction(title: "카메라 촬영", style: .default) { _ in
            self.openCamera()
        }
        let camera = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
            self.openLibrary()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        // alter에 액션을 넣어줌
        alter.addAction(library)
        alter.addAction(camera)
        alter.addAction(cancel)
        
        // button tap했을 때 alter present
        present(alter, animated: true, completion: nil)
    }
    
    // MARK: - @objc
    
    @objc
    func dismissToHabitRoom() {
        dismiss(animated: true, completion: nil)
    }
    
    // 두번째 플로우에서 사진 인증하기 버튼
    @objc
    func touchAuthButton() {
        showAlert()
    }
    
    // 모든 플로우에서 최초 사진 가져온 뒤, 사진 변경 버튼
    @objc
    func touchChangePhotoButton() {
        showAlert()
    }
    
    // 업로드
    @objc
    func touchUploadButton() {
        DispatchQueue.main.async {
            self.setLoading()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.authUploadWithAPI()
        }
    }
    
    @objc
    func popToPresentingVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func showDialog() {
        guard let dialogVC = UIStoryboard(name: Const.Storyboard.Name.dialogue, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.dialogue) as? DialogueVC else { return }
        dialogVC.dialogueType = .exitAuth
        dialogVC.clousure = {
            self.dismiss(animated: true, completion: nil)
        }
        dialogVC.modalPresentationStyle = .overFullScreen
        dialogVC.modalTransitionStyle = .crossDissolve
        self.present(dialogVC, animated: true, completion: nil)
    }
    
    // TODO: 케이스별 액션 구분하기
    @objc
    private func presentToDialogue() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.dialogue, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.dialogue) as? DialogueVC else { return }
        
        nextVC.clousure = {
            self.dismiss(animated: true)
        }
        present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerDelegate

extension AuthUploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImageView.image = image.resize(newWidth: uploadImageView.frame.width*resizeRatio)
            fadeImageView.isHidden = false
            buttonStackView.isHidden = false
            photoAuthButton.isHidden = true
            if vcType == .photoOnly {
                timerLabel.isHidden = true
            } else {
                timerLabel.isHidden = false
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Layout

extension AuthUploadVC {
    private func setLayout() {
        view.addSubviews([titleLabel, closeButton, uploadImageView, fadeImageView,
                          buttonStackView, timerLabel, firstLabel,
                          secondLabel, stopwatchLabel, photoLabel,
                          betweenLine, photoAuthButton])

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton.snp.centerY)
        }
        
        betweenLine.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(2)
        }
        
        firstLabel.snp.makeConstraints { make in
            make.centerY.equalTo(betweenLine.snp.centerY)
            make.trailing.equalTo(betweenLine.snp.leading).offset(-20)
        }
        
        secondLabel.snp.makeConstraints { make in
            make.centerY.equalTo(betweenLine.snp.centerY)
            make.leading.equalTo(betweenLine.snp.trailing).offset(20)
        }
        
        stopwatchLabel.snp.makeConstraints { make in
            make.centerX.equalTo(firstLabel.snp.centerX)
            make.top.equalTo(firstLabel.snp.bottom).offset(6)
        }
        
        photoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(secondLabel.snp.centerX)
            make.top.equalTo(secondLabel.snp.bottom).offset(6)
        }
        
        photoAuthButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        uploadImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(uploadImageView.snp.width).multipliedBy(1.0/1.0)
        }
        
        fadeImageView.snp.makeConstraints { make in
            make.edges.equalTo(uploadImageView.snp.edges)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(self.view.frame.width*48/335)
        }
        
        changePhotoButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(160)
        }
        
        uploadButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(160)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(uploadImageView)
        }
    }
}

// MARK: Network

extension AuthUploadVC {
    func authUploadWithAPI() {
        RoomAPI.shared.authUpload(roomID: roomId ?? 0, timer: timerLabel.text ?? "", image: uploadImageView.image ?? UIImage()) {  response in
            switch response {
            case .success(let data):
                if let authUpload = data as? AuthUpload {
                    self.loadingView.stop()
                    self.loadingBgView.removeFromSuperview()
                    
                    guard let popupVC = UIStoryboard(name: Const.Storyboard.Name.completeAuth, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.completeAuth) as? CompleteAuthVC else {return}
                    
                    popupVC.renderedImage = self.uploadImageView.image
                    popupVC.roomName = authUpload.roomName
                    popupVC.nickName = authUpload.nickname
                    popupVC.profileImage = authUpload.profileImg
                    popupVC.timerCount = self.timerLabel.text
                    
                    popupVC.vcType = self.vcType
                    popupVC.modalTransitionStyle = .crossDissolve
                    popupVC.modalPresentationStyle = .overFullScreen
                    
                    self.present(popupVC, animated: true)
                }
            case .requestErr(let message):
                print("authUploadWithAPI - requestErr \(message)")
            case .pathErr:
                print("authUploadWithAPI - pathErr")
            case .serverErr:
                print("authUploadWithAPI - serverErr")
            case .networkFail:
                print("authUploadWithAPI - networkFail")
            }
        }
    }
}
