//
//  AuthUploadVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/16.
//

import UIKit

import SnapKit

@frozen enum VCCase {
//    case cameraTimer
    case photoTimer
    case photoOnly
//    case albumOnly
}

class AuthUploadVC: UIViewController {
    
    // MARK: - Properties
    
    var vcType: VCCase = .photoTimer
    var roomID: Int?
    var uploadImageView = UIImageView()
    let fadeImageView = UIImageView()
    var uploadImage = UIImage()
    var buttonStackView = UIStackView()
    var uploadButton = UIButton()
    var changePhotoButton = UIButton()
    var timerLabel = UILabel()
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    let stopwatchLabel = UILabel()
    let photoLabel = UILabel()
    let betweenLine = UIView()
    let photoAuthButton = UIButton()
    let picker = UIImagePickerController()
    var getTime: String = ""
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        setAddTarget()
    }
}

// MARK: - Methods

extension AuthUploadVC {
    private func setUI() {
        firstLabel.text = "1"
        secondLabel.text = "2"
        stopwatchLabel.text = "스톱워치"
        photoLabel.text = "사진"
        
        firstLabel.textColor = .sparkGray
        secondLabel.textColor = .sparkPinkred
        stopwatchLabel.textColor = .sparkGray
        photoLabel.textColor = .sparkPinkred
        
        firstLabel.font = .enMediumFont(ofSize: 18)
        secondLabel.font = .enMediumFont(ofSize: 18)
        stopwatchLabel.font = .krMediumFont(ofSize: 18)
        photoLabel.font = .krRegularFont(ofSize: 18)
        
        betweenLine.backgroundColor = .sparkPinkred
        
        photoAuthButton.layer.cornerRadius = 2
        photoAuthButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        photoAuthButton.setTitle("사진 인증하기", for: .normal)
        photoAuthButton.backgroundColor = .sparkDarkPinkred
        
        fadeImageView.backgroundColor = .sparkBlack.withAlphaComponent(0.15)
        uploadImageView.contentMode = .scaleAspectFill
        uploadImageView.layer.masksToBounds = true
        
        setStackView()
        
        timerLabel.text = "00:30:12"
        timerLabel.font = .enBoldFont(ofSize: 40)
        timerLabel.textColor = .sparkWhite
        
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
        uploadButton.setTitle("업로드", for: .normal)
        uploadButton.backgroundColor = .sparkDarkPinkred
        uploadButton.isEnabled = true
        
        switch vcType {
        case .photoOnly:
            print("📷사진인증만")
            timerLabel.isHidden = true
            setFirstFlowUI()
            
//        case .albumOnly:
//            print("앨범")
////            changePhotoButton.setTitle("다시 선택", for: .normal)
//            timerLabel.isHidden = true
//            setFirstFlowUI()
//
//        case .cameraTimer:
//            print("카메라타이머")
//            setSecondFlowUI()
            
        case .photoTimer:
            print("📷사진+🕚타이머")
//            changePhotoButton.setTitle("다시 선택", for: .normal)
            setSecondFlowUI()
        }
    }
    
    private func setDelegate() {
        picker.delegate = self
    }
    
    private func setAddTarget() {
        photoAuthButton.addTarget(self, action: #selector(touchAuthButton), for: .touchUpInside)
        changePhotoButton.addTarget(self, action: #selector(touchChangePhotoButton), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(touchUploadButton), for: .touchUpInside)
    }
    
    // 사진 인증만 하는 플로우 UI
    func setFirstFlowUI() {
        [firstLabel, secondLabel, stopwatchLabel,
         photoLabel, betweenLine, photoAuthButton].forEach { $0.isHidden = true }
        [uploadImageView, buttonStackView, fadeImageView].forEach { $0.isHidden = false }
        
        uploadImageView.image = uploadImage
    }
    
    // 스톱워치 + 사진 인증하는 플로우 UI
    func setSecondFlowUI() {
        [firstLabel, secondLabel, stopwatchLabel,
         photoLabel, betweenLine, photoAuthButton].forEach { $0.isHidden = false }
        [buttonStackView, timerLabel, fadeImageView].forEach { $0.isHidden = true }
        
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
        /// UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 앨범에서 픽해오겠다
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
//        vcType = .photoTimer
//        changePhotoButton.setTitle("다시 선택", for: .normal)
    }
    
    private func openCamera() {
        /// 카메라 촬영 타입이 가능하다면
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            /// UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 카메라 촬영헤서 픽해오겠다
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
//            vcType = .photoOnly
//            changePhotoButton.setTitle("다시 찍기", for: .normal)
        } else {
            print("카메라 안됩니다.")
        }
    }
    
    private func showAlert() {
        let alter = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alter.view.tintColor = .sparkBlack
        
        /// alter에 들어갈 액션 생성
        let library = UIAlertAction(title: "카메라 촬영", style: .default) { _ in
            self.openCamera()
        }
        let camera = UIAlertAction(title: "앨범에서 선택하기", style: .default) { _ in
            self.openLibrary()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        /// alter에 액션을 넣어줌
        alter.addAction(library)
        alter.addAction(camera)
        alter.addAction(cancel)
        
        /// button tap했을 때 alter present
        present(alter, animated: true, completion: nil)
    }
    
    @objc
    func touchAuthButton() {
        showAlert()
    }
    
    // 다시 선택 & 다시 찍기
    @objc
    func touchChangePhotoButton() {
        showAlert()
//        if changePhotoButton.titleLabel?.text == "다시 선택" {
//            self.openLibrary()
//        } else {
//            self.openCamera()
//        }
    }
    
    // TODO: 업로드 시간이 길다. 로딩 넣기.
    // 업로드
    @objc
    func touchUploadButton() {
        authUploadWithAPI()
    }
}

// MARK: - UIImagePickerDelegate

extension AuthUploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImageView.image = image
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
        view.addSubviews([uploadImageView, fadeImageView, buttonStackView,
                          timerLabel, firstLabel, secondLabel,
                          stopwatchLabel, photoLabel, betweenLine, photoAuthButton])

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
            make.height.equalTo(self.view.frame.width*48/335)
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
        RoomAPI.shared.authUpload(roomID: roomID ?? 0, timer: timerLabel.text ?? "", image: uploadImageView.image ?? UIImage()) {  response in
            switch response {
            case .success(let data):
                if let authUpload = data as? AuthUpload {
                    print(authUpload)
                    
                    guard let popupVC = UIStoryboard(name: Const.Storyboard.Name.completeAuth, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.completeAuth) as? CompleteAuthVC else {return}
                    
                    popupVC.modalTransitionStyle = .crossDissolve
                    popupVC.modalPresentationStyle = .overFullScreen
                    
                    self.present(popupVC, animated: true, completion: nil)
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
