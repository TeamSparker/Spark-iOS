//
//  EditProfileVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/04.
//

import UIKit

class EditProfileVC: UIViewController {

    // MARK: - Properties
    
    private var customNavigationBar = LeftButtonNavigaitonBar()
    private let profileImageView = UIImageView()
    private let fadeView = UIView()
    private let photoIconImageView = UIImageView()
    private let textField = UITextField()
    private let lineView = UIView()
    private let countLabel = UILabel()
    private var completeButton = BottomButton().setUI(.pink).setTitle("수정 완료").setAble()
    private let picker = UIImagePickerController()
    private let tap = UITapGestureRecognizer()
    
    private let maxLength: Int = 10
    private var didEdit: Bool = false
    
    weak var profileImageDelegate: ProfileImageDelegate?
    
    var profileImage: UIImage?
    var nickname: String?
    
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
}
    
    // MARK: - Extension
extension EditProfileVC {
    private func setUI() {
        customNavigationBar.title("프로필 수정")
            .leftButtonImage("icQuit")
            .leftButtonAction {
                if self.didEdit {
                    guard let dialougeVC = UIStoryboard(name: Const.Storyboard.Name.dialogue, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.dialogue) as? DialogueVC else { return }
                    
                    dialougeVC.dialogueType = .exitEditProfile
                    dialougeVC.clousure = {
                        self.dismiss(animated: true, completion: nil)
                    }
                    dialougeVC.modalTransitionStyle = .crossDissolve
                    dialougeVC.modalPresentationStyle = .overFullScreen
                    self.present(dialougeVC, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        
        profileImageView.image = profileImage
        profileImageView.layer.cornerRadius = 58
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        
        fadeView.backgroundColor = .sparkBlack.withAlphaComponent(0.6)
        fadeView.layer.cornerRadius = 58
        fadeView.addGestureRecognizer(tap)
        
        photoIconImageView.image = UIImage(named: "icImage")
        
        textField.borderStyle = .none
        textField.placeholder = nickname
        textField.text = nickname
        textField.tintColor = .sparkPinkred
        
        lineView.backgroundColor = .sparkPinkred
        
        countLabel.text = "0/10"
        countLabel.font = .captionEng
        countLabel.textColor = .sparkDarkGray
        changeCountLabel(textField: textField, maxLength: maxLength, countLabel: countLabel)
    }
    
    private func setDelegate() {
        textField.delegate = self
        picker.delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateKeyboardFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setAddTarget() {
        completeButton.addTarget(self, action: #selector(touchCompleteButton), for: .touchUpInside)
        tap.addTarget(self, action: #selector(showAlert))
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    // MARK: - @objc
    
    @objc
    private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            self.changeCountLabel(textField: textField, maxLength: maxLength, countLabel: countLabel)
        }
    }
    
    @objc
    func showAlert() {
        didEdit = true
        
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
        if profileImageView.image == UIImage(named: "profileEmpty") {
            profileEditWithAPI(profileImage: nil) {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            profileEditWithAPI(profileImage: profileImageView.image) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        profileImageDelegate?.sendProfile(image: profileImageView.image ?? UIImage(named: "profileEmpty")!,
                                          nickname: textField.text ?? "")
    }
    
    @objc
    func updateKeyboardFrame(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardY = keyboardFrame.cgRectValue.minY
        let lineViewMinimumYMargin = lineView.frame.maxY + 20 // 키보드와 lineView 와의 최소 간격 20.
        let profileImageViewY = profileImageView.frame.minY - customNavigationBar.frame.maxY // 커스텀 네비바로부터 profileImage 의 간격.
        let profileImageViewDefaultY = 128.0 // 커스텀 네비바와 profileImageView 의 기본 간격.

        UIView.animate(withDuration: 0.3) {
            if keyboardY != UIScreen.main.bounds.height {
                // 키보드가 올라온다고 판단.
                let updateProfileImageViewY = profileImageViewY - (lineViewMinimumYMargin - keyboardY)
                if updateProfileImageViewY > profileImageViewDefaultY {
                    // 업데이트 될 profileImageView 가 기본 위치보다 아래일때
                    self.profileImageView.snp.updateConstraints {
                        $0.top.equalTo(self.customNavigationBar.snp.bottom).offset(profileImageViewDefaultY)
                    }
                } else {
                    self.profileImageView.snp.updateConstraints {
                        $0.top.equalTo(self.customNavigationBar.snp.bottom).offset(updateProfileImageViewY)
                    }
                }
            } else {
                // 키보드가 내려감.
                self.profileImageView.snp.updateConstraints {
                    $0.top.equalTo(self.customNavigationBar.snp.bottom).offset(profileImageViewDefaultY)
                }
            }
            self.profileImageView.superview?.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileVC: UITextFieldDelegate {
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
        didEdit = true
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
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // UIImage 타입인 originalImage를 빼옴
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image.resize()
            profileImageView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Network

extension EditProfileVC {
    private func profileEditWithAPI(profileImage: UIImage?, completion: @escaping (() -> Void)) {
        let nickname = textField.text
        UserAPI(viewController: self).profileEdit(profileImage: profileImage, nickname: nickname ?? "") { response in
            switch response {
            case .success(let message):
                completion()
                print("profileEditWithAPI - success: \(message)")
            case .requestErr(let message):
                print("profileEditWithAPI - requestErr: \(message)")
            case .pathErr:
                print("profileEditWithAPI - pathErr")
            case .serverErr:
                print("profileEditWithAPI - serverErr")
            case .networkFail:
                print("profileEditWithAPI - networkFail")
            }
        }
    }
}

// MARK: - Layout

extension EditProfileVC {
    private func setLayout() {
        view.addSubviews([customNavigationBar, profileImageView,
                          fadeView, textField, lineView,
                          countLabel, completeButton])
        
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(customNavigationBar.snp.bottom).offset(128)
            make.width.height.equalTo(115)
        }
        
        fadeView.addSubview(photoIconImageView)
        
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
