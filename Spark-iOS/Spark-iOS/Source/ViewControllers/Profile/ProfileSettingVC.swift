//
//  ProfileSettingVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/19.
//

import UIKit

import FirebaseAnalytics
import Lottie
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
    
    private lazy var loadingBgView = UIView()
    private lazy var loadingView = AnimationView(name: Const.Lottie.Name.loading)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setNotification()
        setAddTarget()
        setDelegate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObservers()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        closeButton.setImage(UIImage(named: "icQuit"), for: .normal)
        titleLabel.text = "스파크에서 사용할 \n프로필을 설정해주세요!"
        titleLabel.font = .h2Title
        titleLabel.textColor = .sparkBlack
        titleLabel.numberOfLines = 2
        titleLabel.partColorChange(targetString: "프로필", textColor: .sparkPinkred)
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateKeyboardFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    private func tracking() {
        Analytics.logEvent(Tracking.Select.clickSignup, parameters: nil)
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
                alert.dismiss(animated: true) {
                    self.profileImageView.image = UIImage(named: "profileEmpty")
                }
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
        setLoading()
        let profileImage = profileImageView.image == UIImage(named: "profileEmpty") ? nil : profileImageView.image?.resize()
        signupWithAPI(profileImage: profileImage, nickname: textField.text ?? "") {
            NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
            self.presentToMainTBC()
            self.tracking()
        }
    }
    
    @objc
    func touchCloseButton() {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func updateKeyboardFrame(_ notification: Notification) {
        guard let keyboardEndFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let keyboardBeginFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keyboardEndY = keyboardEndFrame.cgRectValue.minY
        let keyboardBeginY = keyboardBeginFrame.cgRectValue.minY
        let minimumMargin = 20.0 // 최소한의 간격
        let lineViewMinimumYMargin = lineView.frame.maxY + minimumMargin // 키보드와 lineView 와의 최소 간격 20 포함.
        let profileImageViewTopConstraint = profileImageView.frame.minY - titleLabel.frame.maxY // titleLabel 로부터 profileImage 의 간격.
        let textFieldTopConstraint = textField.frame.minY - profileImageView.frame.maxY // prfileImageView 와 textField 의 간격.
        
        let profileImageViewDefaultTopConstraint = 66.0 // titleLabel 과 profileImageView 의 기본 간격.
        let textFieldDefaultTopConstraint = 55.0 // prfileImageView 와 textField 의 기본 간격.
        
        UIView.animate(withDuration: 0.3) {
            if keyboardEndY != UIScreen.main.bounds.height {
                // 키보드가 올라온다고 판단.
                let updatedProfileImageViewTopConstraint = profileImageViewTopConstraint - (lineViewMinimumYMargin - keyboardEndY)
                if  updatedProfileImageViewTopConstraint > profileImageViewDefaultTopConstraint {
                    // 업데이트 될 profileImageView 가 기본 위치보다 아래일때.
                    if lineViewMinimumYMargin == keyboardBeginY {
                        // 이모지 키보드에서 기본 키보드로 변경될때.
                        let keyboardDifferenceY = keyboardEndY - keyboardBeginY
                        let updatedProfileImageViewTopConstraint = profileImageViewTopConstraint + keyboardDifferenceY - ( textFieldDefaultTopConstraint - textFieldTopConstraint)
                        self.profileImageView.snp.updateConstraints {
                            $0.top.equalTo(self.titleLabel.snp.bottom).offset(updatedProfileImageViewTopConstraint)
                        }
                        self.textField.snp.updateConstraints {
                            $0.top.equalTo(self.profileImageView.snp.bottom).offset(textFieldDefaultTopConstraint)
                        }
                    } else {
                        // 키보드와 lineView 가 최소 간격보다 멀어서 굳이 레이아웃을 대응해주지 않아도 될 때
                        self.profileImageView.snp.updateConstraints {
                            $0.top.equalTo(self.titleLabel.snp.bottom).offset(profileImageViewDefaultTopConstraint)
                        }
                        self.textField.snp.updateConstraints {
                            $0.top.equalTo(self.profileImageView.snp.bottom).offset(textFieldDefaultTopConstraint)
                        }
                    }
                } else {
                    if minimumMargin > updatedProfileImageViewTopConstraint {
                        // 업데이트 될 profileIma geView 가 titleLabel 보다 높게 위치할때(가릴 때)
                        let updatedTextFieldTopConstraint = minimumMargin - updatedProfileImageViewTopConstraint
                        self.profileImageView.snp.updateConstraints {
                            $0.top.equalTo(self.titleLabel.snp.bottom).offset(minimumMargin)
                        }
                        self.textField.snp.updateConstraints {
                            $0.top.equalTo(self.profileImageView.snp.bottom).offset(textFieldTopConstraint - updatedTextFieldTopConstraint)
                        }
                    } else {
                        // 가리지 않을 때.
                        self.profileImageView.snp.updateConstraints {
                            $0.top.equalTo(self.titleLabel.snp.bottom).offset(updatedProfileImageViewTopConstraint)
                        }
                        self.textField.snp.updateConstraints {
                            $0.top.equalTo(self.profileImageView.snp.bottom).offset(textFieldDefaultTopConstraint)
                        }
                    }
                }
            } else {
                // 키보드가 내려감.
                self.profileImageView.snp.updateConstraints {
                    $0.top.equalTo(self.titleLabel.snp.bottom).offset(profileImageViewDefaultTopConstraint)
                }
                self.textField.snp.updateConstraints {
                    $0.top.equalTo(self.profileImageView.snp.bottom).offset(textFieldDefaultTopConstraint)
                }
            }
            self.profileImageView.superview?.layoutIfNeeded()
        }
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
            profileImageView.image = image.resize()
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
            make.top.equalTo(titleLabel.snp.bottom).offset(66)
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
    private func signupWithAPI(profileImage: UIImage?, nickname: String, completion: @escaping () -> Void) {
        let socialID: String
        if UserDefaultsManager.isAppleLogin {
            socialID = "Apple@\(UserDefaultsManager.userID ?? "")"
        } else {
            socialID = "Kakao@\(UserDefaultsManager.userID ?? "")"
        }
        AuthAPI(viewController: self).signup(socialID: socialID,
                                             profileImg: profileImage,
                                             nickname: nickname,
                                             fcmToken: UserDefaultsManager.fcmToken ?? "") { response in
            switch response {
            case .success(let data):
                if let signup = data as? Signup {
                    UserDefaultsManager.accessToken = signup.accesstoken
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
