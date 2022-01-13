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
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let textField = UITextField()
    let lineView = UIView()
    let countLabel = UILabel()
    let nextButton = UIButton()
    
    var maxLength: Int = 15

    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setNotification()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        titleLabel.text = "어떤 습관방을 만들건가요?"
        titleLabel.font = .h2Title
        titleLabel.textColor = .sparkBlack
        
        subTitleLabel.text = "진행할 습관을 담아 방 이름을 \n설정해보세요!"
        subTitleLabel.numberOfLines = 2
        subTitleLabel.font = .krRegularFont(ofSize: 18)
        subTitleLabel.textColor = .sparkDarkGray
        
        nextButton.backgroundColor = .gray
        
        textField.borderStyle = .none
        textField.placeholder = "30분 독서"
        textField.delegate = self

        lineView.backgroundColor = .sparkGray

        countLabel.text = "0/15"
        countLabel.font = .p2SubtitleEng
        countLabel.textColor = .sparkDarkGray
    }
    
    private func setLayout() {
        view.addSubviews([titleLabel, subTitleLabel, textField,
                          lineView, countLabel,nextButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
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
            make.height.equalTo(48) /// 버튼 이미지
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func ableButton() {
        lineView.backgroundColor = .sparkPinkred
        nextButton.backgroundColor = .sparkPinkred
    }
    
    private func disableButton() {
        lineView.backgroundColor = .sparkGray
        nextButton.backgroundColor = .sparkGray
    }
    
    @objc
    private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                /// 글자가 바뀔 때마다 countLabel 업데이트
                countLabel.text = "\(text.count)/15"
                
                /// 글자수 count
                if text.count > maxLength {
                    let maxIndex = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = String(text[text.startIndex..<maxIndex])
                    textField.text = newString
                }
                
                /// 글자 있는 경우 색 활성화, 없는 경우 비활성화
                if text.count > 0 {
                    let attributedString = NSMutableAttributedString(string: countLabel.text ?? "")
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.sparkPinkred, range: ((countLabel.text ?? "") as NSString).range(of:"\(text.count)"))
                    countLabel.attributedText = attributedString
                }
            }
        }
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
