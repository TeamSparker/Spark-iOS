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
    
    var maxLength: Int = 15

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setNotification()
        setAddTarget()
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
        
        photoIconImageView.image = UIImage(named: "icImage")
        
        textField.borderStyle = .none
        textField.placeholder = "닉네임 입력"
        textField.delegate = self

        lineView.backgroundColor = .sparkGray

        countLabel.text = "0/15"
        countLabel.font = .p2SubtitleEng
        countLabel.textColor = .sparkDarkGray
        
        completeButton.layer.cornerRadius = 2
        completeButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        completeButton.setTitle("가입 완료", for: .normal)
        completeButton.backgroundColor = .sparkGray
        completeButton.isEnabled = false
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func setAddTarget() {
        completeButton.addTarget(self, action: #selector(touchCompleteButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(touchCloseButton), for: .touchUpInside)
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
    func touchCompleteButton() {
        // TODO: - 화면 전환
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(self.view.frame.width*48/335)
        }
    }
}
