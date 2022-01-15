//
//  HabitAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit

class HabitAuthVC: UIViewController {

    // MARK: - Properties
    
    let picker = UIImagePickerController()
    var imageContainer = UIImage()
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var considerButton: UIButton!
    @IBOutlet weak var restButton: UIButton!

    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAddTargets()
        setDelegate()
    }
}

// MARK: Methods
extension HabitAuthVC {
    func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        popUpView.layer.cornerRadius = 2
        
        okButton.isEnabled = true
        okButton.layer.cornerRadius = 2
        okButton.titleLabel?.text = "지금 습관 인증하기"
        okButton.backgroundColor = .sparkDarkPinkred
        okButton.tintColor = .sparkGray
        okButton.setTitleColor(.sparkGray, for: .highlighted)
        
        // TODO: 고민중, 쉴래요 버튼 기능 구현
        considerButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        considerButton.layer.borderColor = .init(_colorLiteralRed: 1, green: 137/255, blue: 165/255, alpha: 1)
        considerButton.layer.borderWidth = 1
        considerButton.layer.cornerRadius = 2
        
        restButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        restButton.layer.borderColor = .init(_colorLiteralRed: 1, green: 137/255, blue: 165/255, alpha: 1)
        restButton.layer.borderWidth = 1
        restButton.layer.cornerRadius = 2
    }
    
    func setAddTargets() {
        okButton.addTarget(self, action: #selector(touchOkayButton), for:. touchUpInside)
    }
    
    func setDelegate() {
        picker.delegate = self
    }
    
    @objc func touchOkayButton() {
        let alter = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alter.view.tintColor = .sparkBlack
        
        /// alter에 들어갈 액션 생성
        let library = UIAlertAction(title: "카메라 촬영", style: .default) { action in
            self.openCamera()
        }
        let camera = UIAlertAction(title: "앨범에서 선택하기", style: .default) { action in
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
    
    func openLibrary() {
        /// UIImagePickerController에서 어떤 식으로 image를 pick해올지 -> 앨범에서 픽해오겠다
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageContainer = image
        }
        dismiss(animated: true) {
            self.presentAuthUpload()
        }
    }
    
    // TODO: 케이스 나눠서 화면전환 하기
    private func presentAuthUpload() {
        let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.authUpload, bundle:nil)
        
        guard let nextVC = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.authUpload) as? AuthUploadVC else {return}
        
        nextVC.uploadImage = self.imageContainer
        
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
}
