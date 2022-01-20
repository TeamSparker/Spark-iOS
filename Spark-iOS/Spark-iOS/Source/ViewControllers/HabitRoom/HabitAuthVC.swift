//
//  HabitAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit
import AVFoundation

@frozen enum AuthType {
    case photoOnly
    case photoTimer
}

class HabitAuthVC: UIViewController {

    // MARK: - Properties
    
    private let picker = UIImagePickerController()
    private var imageContainer = UIImage()
    var authType: AuthType?
    var roomID: Int?
    var rest: Int?
    var roomName: String?
    var presentAlertClosure: (() -> Void)?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var considerButton: UIButton!
    @IBOutlet weak var restButton: UIButton!
    @IBOutlet weak var authTypeImageView: UIImageView!
    @IBOutlet weak var restNumberLabel: UILabel!
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAddTargets()
        setDelegate()
    }
    
    
    @IBAction func touchOutsideDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Methods
extension HabitAuthVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        switch authType {
        case .photoOnly:
            authTypeImageView.image = UIImage(named: "stickerPhotoDefault")
        case .photoTimer:
            authTypeImageView.image = UIImage(named: "stickersBoth")
        case .none:
            print("authType을 지정해주세요")
        }
        
        popUpView.layer.cornerRadius = 2
        
        okButton.isEnabled = true
        okButton.layer.cornerRadius = 2
        okButton.titleLabel?.text = "지금 습관 인증하기"
        okButton.backgroundColor = .sparkDarkPinkred
        okButton.tintColor = .sparkGray
        okButton.setTitleColor(.sparkGray, for: .highlighted)
        
        considerButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        considerButton.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        considerButton.layer.borderWidth = 1
        considerButton.layer.cornerRadius = 2
        
        restButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        restButton.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        restButton.layer.borderWidth = 1
        restButton.layer.cornerRadius = 2
//        if restNumber == 0 {
//            restButton.isEnabled = false
//        }
    }
    
    private func setAddTargets() {
        okButton.addTarget(self, action: #selector(touchOkayButton), for: .touchUpInside)
        considerButton.addTarget(self, action: #selector(touchConsiderButton), for: .touchUpInside)
        restButton.addTarget(self, action: #selector(touchRestButton), for: .touchUpInside)
    }
    
    private func setDelegate() {
        picker.delegate = self
    }
    
    private func showAlert() -> UIViewController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .sparkBlack
        
        /// alter에 들어갈 액션 생성
        let camera = UIAlertAction(title: "카메라 촬영", style: .default) { _ in
            self.openCamera()
        }
        let library = UIAlertAction(title: "앨범에서 선택하기", style: .default) { _ in
            self.openLibrary()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        /// alter에 액션을 넣어줌
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        
        /// button tap했을 때 alter present
//        self.modalTransitionStyle = .coverVertical
        
//        present(alert, animated: true) {
//            guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.authUpload, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.authUpload) as? AuthUploadVC else { return }
//            self.present(nextVC, animated: true, completion: nil)
//        }
        
//        return alert
//        present(alert, animated: true, completion: nil)
        return alert
    }
    
    @objc
    private func touchOkayButton() {
        switch authType {
        case .photoOnly:
            self.dismiss(animated: true) {
            self.presentAlertClosure?()
            }
        case .photoTimer:
            self.dismiss(animated: true) {
                let presentingVC = self.presentingViewController
                guard let rootVC = UIStoryboard(name: Const.Storyboard.Name.authTimer, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.authTimer) as? AuthTimerVC else { return }
                let nextVC = UINavigationController(rootViewController: rootVC)
                nextVC.modalPresentationStyle = .fullScreen
                rootVC.roomId = self.roomID
                rootVC.roomName = self.roomName
                
                presentingVC?.present(nextVC, animated: true, completion: nil)
            }
        default:
            print("아닙니다")
        }
    }
    
    @objc
    private func touchConsiderButton() {
        setConsiderRestWithAPI(statusType: "CONSIDER")
    }
    
    @objc
    private func touchRestButton() {
        setConsiderRestWithAPI(statusType: "REST")
    }
    
    private func openLibrary() {
        /// UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 앨범에서 픽해오겠다
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    private func openCamera() {
        /// 카메라 촬영 타입이 가능하다면
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            /// UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 카메라 촬영헤서 픽해오겠다
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            print("카메라 안됩니다.")
        }
    }
}

// MARK: UIImagePickerDelegate
extension HabitAuthVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageContainer = image
        }
        dismiss(animated: true) {
//            self.presentAuthUpload()
            guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.authUpload, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.authUpload) as? AuthUploadVC else { return }
            
            nextVC.roomName = self.roomName
            nextVC.roomId = self.roomID
            
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    // TODO: 케이스 나눠서 화면전환 하기
//    private func presentAuthUpload() {
//        let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.authUpload, bundle: nil)
//
//        guard let nextVC = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.authUpload) as? AuthUploadVC else {return}
//
//        nextVC.uploadImage = self.imageContainer
//
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: false, completion: nil)
//    }
}

// MARK: Network

extension HabitAuthVC {
    func setConsiderRestWithAPI(statusType: String) {
        RoomAPI.shared.setConsiderRest(roomID: roomID ?? 0, statusType: statusType) {  response in
            switch response {
            case .success(_):
                self.dismiss(animated: true, completion: nil)
            case .requestErr(let message):
                print("setConsiderRestWithAPI - requestErr: \(message)")
            case .pathErr:
                print("setConsiderRestWithAPI - pathErr")
            case .serverErr:
                print("setConsiderRestWithAPI - serverErr")
            case .networkFail:
                print("setConsiderRestWithAPI - networkFail")
            }
        }
    }
}
