//
//  CreateRoomVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//

import UIKit

import SnapKit

class CreateRoomVC: UIViewController {
    
    // MARK: - Properties
    
    let closeButton = UIButton()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let textField = UITextField()
    let lineView = UIView()
    let countLabel = UILabel()
    let nextButton = UIButton()
    
    var maxLength: Int = 15

    // MARK: - View Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
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
        
        titleLabel.text = "어떤 습관방을 만들건가요?"
        titleLabel.font = .h2Title
        titleLabel.textColor = .sparkBlack
        
        subTitleLabel.text = "진행할 습관을 담아 방 이름을 \n설정해보세요!"
        subTitleLabel.numberOfLines = 2
        subTitleLabel.font = .krRegularFont(ofSize: 18)
        subTitleLabel.textColor = .sparkDarkGray
        
        nextButton.layer.cornerRadius = 2
        nextButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        nextButton.setTitle("다음", for: .normal)
        nextButton.backgroundColor = .sparkGray
        nextButton.isEnabled = false
        
        textField.borderStyle = .none
        textField.placeholder = "ex. 30분 독서"
        textField.delegate = self

        lineView.backgroundColor = .sparkGray

        countLabel.text = "0/15"
        countLabel.font = .p2SubtitleEng
        countLabel.textColor = .sparkDarkGray
    }
    
    private func setLayout() {
        view.addSubviews([titleLabel, subTitleLabel, textField,
                          lineView, countLabel, nextButton, closeButton])
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(14)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(96)
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
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(self.view.frame.width*48/335)
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func setAddTarget() {
        nextButton.addTarget(self, action: #selector(touchNextButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(touchCloseButton), for: .touchUpInside)
    }
    
    private func ableButton() {
        lineView.backgroundColor = .sparkPinkred
        nextButton.backgroundColor = .sparkPinkred
        nextButton.isEnabled = true
    }
    
    private func disableButton() {
        lineView.backgroundColor = .sparkGray
        nextButton.backgroundColor = .sparkGray
        nextButton.isEnabled = false
    }
    
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
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.sparkPinkred, range: ((countLabel.text ?? "") as NSString).range(of:"\(text.count)"))
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
    func touchNextButton() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.createAuth, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.createAuth) as? CreateAuthVC else { return }
        nextVC.roomName = textField.text ?? ""
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    func touchCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateRoomVC: UITextFieldDelegate {
    /// 여백 클릭 시
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
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
