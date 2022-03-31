//
//  ProfileSettingVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/19.
//

import UIKit

import SnapKit

class ProfileSettingVC: UIViewController {
    
    // MARK: - Properties
    
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let fadeView = UIView()
    private let photoIconImageView = UIImageView()
    private let textField = UITextField()
    private let lineView = UIView()
    private let countLabel = UILabel()
    private var completeButton = BottomButton().setUI(.pink).setTitle("가입완료").setDisable()
    private let picker = UIImagePickerController()
    private let tap = UITapGestureRecognizer()
    private let maxLength: Int = 10
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setNotification()
        setAddTarget()
        setDelegate()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        closeButton.setImage(UIImage(named: "icQuit"), for: .normal)
        titleLabel.text = "스파크에서 사용할 \n프로필을 설정해주세요!"
        titleLabel.font = .h2Title
        titleLabel.textColor = .sparkBlack
        titleLabel.numberOfLines = 2
        titleLabel.partColorChange(targetString: "프로필", textColor: .sparkPinkred)
        
        profileImageView.backgroundColor = .blue
        profileImageView.image = UIImage(named: "profileEmpty")
        profileImageView.layer.cornerRadius = 58
        profileImageView.layer.masksToBounds = true
        
        fadeView.backgroundColor = .sparkBlack.withAlphaComponent(0.6)
        fadeView.layer.cornerRadius = 58
        fadeView.addGestureRecognizer(tap)
        
        photoIconImageView.image = UIImage(named: "icImage")
        
        textField.borderStyle = .none
        textField.placeholder = "닉네임 입력"
        textField.tintColor = .sparkPinkred
        
        lineView.backgroundColor = .sparkGray
        
        countLabel.text = "0/10"
        countLabel.font = .p2SubtitleEng
        countLabel.textColor = .sparkDarkGray
    }
    
    private func setDelegate() {
        textField.delegate = self
        picker.delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func setAddTarget() {
        completeButton.addTarget(self, action: #selector(touchCompleteButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(touchCloseButton), for: .touchUpInside)
        tap.addTarget(self, action: #selector(showAlert))
    }
    
    private func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
    }
    
    private func presentToMainTBC() {
        guard let mainVC = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar) as? MainTBC else { return }
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        
        present(mainVC, animated: true, completion: nil)
    }
    
    // MARK: - @objc
    
    @objc
    private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            self.changeCountLabel(textField: textField, maxLength: maxLength, countLabel: countLabel)
        }
    }
    
    @objc
    func showAlert() {
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
        
        if profileImageView.image != UIImage(named: "profileEmpty") {
            alert.addAction(SparkAction("사진 삭제", titleType: .blackMediumTitle, handler: {
                self.profileImageView.image = UIImage(named: "profileEmpty")
            }))
        }
        
        alert.addSection()
        
        alert.addAction(SparkAction("취소", titleType: .blackBoldTitle, handler: {
            alert.animatedDismiss(completion: nil)
        }))
        
        present(alert, animated: true)
    }
    
    @objc
    func touchCompleteButton() {
        if profileImageView.image == UIImage(named: "profileEmpty") {
            signupWithAPI(profileImg: nil, nickname: textField.text ?? "") {
                NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
                self.presentToMainTBC()
            }
        } else {
            signupWithAPI(profileImg: profileImageView.image ?? UIImage(), nickname: textField.text ?? "") {
                NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
                self.presentToMainTBC()
            }
        }
    }
    
    @objc
    func touchCloseButton() {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension ProfileSettingVC: UITextFieldDelegate {
    // 여백 클릭 시
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 리턴 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // 입력 시작
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        lineView.backgroundColor = .sparkPinkred
        return true
    }
    
    // 입력 끝
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText {
            completeButton.setAble()
            lineView.backgroundColor = .sparkPinkred
        } else {
            completeButton.setDisable()
            lineView.backgroundColor = .sparkGray
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileSettingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // UIImage 타입인 originalImage를 빼옴
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image.resize(newWidth: profileImageView.frame.width)
            profileImageView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Layout

extension ProfileSettingVC {
    private func setLayout() {
        view.addSubviews([closeButton, titleLabel, profileImageView,
                          fadeView, textField, lineView,
                          countLabel, completeButton])
        fadeView.addSubview(photoIconImageView)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(188)
            make.width.height.equalTo(115)
        }
        
        fadeView.snp.makeConstraints { make in
            make.edges.equalTo(profileImageView)
        }
        
        photoIconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(55)
            make.leading.equalToSuperview().inset(36)
            make.width.equalTo(290)
            make.height.equalTo(46)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.trailing.equalToSuperview().inset(28)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28)
            make.top.equalTo(textField.snp.bottom)
            make.height.equalTo(2)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - Network

extension ProfileSettingVC {
    private func signupWithAPI(profileImg: UIImage?, nickname: String, completion: @escaping () -> Void) {
        let socialID: String
        if UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.isAppleLogin) {
            socialID = "Apple@\(UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "")"
        } else {
            socialID = "Kakao@\(UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "")"
        }
        AuthAPI.shared.signup(socialID: socialID,
                              profileImg: profileImg,
                              nickname: nickname,
                              fcmToken: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.fcmToken) ?? "") { response in
            switch response {
            case .success(let data):
                if let signup = data as? Signup {
                    UserDefaults.standard.set(signup.accesstoken, forKey: Const.UserDefaultsKey.accessToken)
                }
                
                completion()
            case .requestErr(let message):
                print("signupWithAPI - requestErr: \(message)")
            case .pathErr:
                print("signupWithAPI - pathErr")
            case .serverErr:
                print("signupWithAPI - serverErr")
            case .networkFail:
                print("signupWithAPI - networkFail")
            }
            
        }
    }
}
