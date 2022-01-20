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
    
    let closeButton = UIButton()
    let titleLabel = UILabel()
    let profileImageView = UIImageView()
    let fadeView = UIView()
    let photoIconImageView = UIImageView()
    let textField = UITextField()
    let lineView = UIView()
    let countLabel = UILabel()
    let completeButton = UIButton()
    let picker = UIImagePickerController()
    let tap = UITapGestureRecognizer()
    
    var maxLength: Int = 15
    
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
        
        lineView.backgroundColor = .sparkGray
        
        countLabel.text = "0/15"
        countLabel.font = .p2SubtitleEng
        countLabel.textColor = .sparkDarkGray
        
        completeButton.layer.cornerRadius = 2
        completeButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        completeButton.setTitle("가입완료", for: .normal)
        completeButton.backgroundColor = .sparkGray
        completeButton.isEnabled = false
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
        tap.addTarget(self, action: #selector(showAlter))
    }
    
    private func ableButton() {
        lineView.backgroundColor = .sparkPinkred
        completeButton.backgroundColor = .sparkPinkred
        completeButton.isEnabled = true
    }
    
    private func disableButton() {
        lineView.backgroundColor = .sparkGray
        completeButton.backgroundColor = .sparkGray
        completeButton.isEnabled = false
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
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar) as? MainTBC else { return }
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .fullScreen
        
        present(nextVC, animated: true, completion: nil)
    }
    
    // MARK: - @objc
    
    @objc
    private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                /// 글자가 바뀔 때마다 countLabel 업데이트
                countLabel.text = "\(text.count)/15"
                
                /// 글자수 count 초과한 경우
                if text.count >= maxLength {
                    let maxIndex = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = String(text[text.startIndex..<maxIndex])
                    textField.text = newString
                    countLabel.text = "15/15"
                    countLabel.textColor = .sparkPinkred
                }
                
                /// 글자 있는 경우 색 활성화, 없는 경우 비활성화
                else if text.count > 0 {
                    let attributedString = NSMutableAttributedString(string: countLabel.text ?? "")
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.sparkPinkred, range: ((countLabel.text ?? "") as NSString).range(of: "\(text.count)"))
                    countLabel.textColor = .sparkDarkGray
                    countLabel.attributedText = attributedString
                }
                
                /// 그 외 0인 경우
                else {
                    countLabel.textColor = .sparkDarkGray
                }
            }
        }
    }
    
    @objc
    func showAlter() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .sparkBlack
        
        let library = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
            self.openLibrary()
        }
        
        let camera = UIAlertAction(title: "카메라 촬영", style: .default) { _ in
            self.openCamera()
        }
        
        let delete = UIAlertAction(title: "사진 삭제", style: .default) { _ in
            self.profileImageView.image = UIImage(named: "profileEmpty")
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        if profileImageView.image != UIImage(named: "profileEmpty") {
            alert.addAction(delete)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func touchCompleteButton() {
        signupWithAPI(profileImg: profileImageView.image ?? UIImage(), nickname: textField.text ?? "") {
            self.presentToMainTBC()
        }
    }
    
    @objc
    func touchCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension ProfileSettingVC: UITextFieldDelegate {
    /// 여백 클릭 시
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// 리턴 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    /// 입력 시작
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        ableButton()
        return true
    }
    
    /// 입력 끝
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText {
            ableButton()
        } else {
            disableButton()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileSettingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // UIImage 타입인 originalImage를 빼옴
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
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
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(290)
            make.height.equalTo(46)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.trailing.equalToSuperview().inset(28)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom)
            make.height.equalTo(2)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(self.view.frame.width*48/335)
        }
    }
}

// MARK: - Network

extension ProfileSettingVC {
    private func signupWithAPI(profileImg: UIImage, nickname: String, completion: @escaping () -> Void) {
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
