//
//  GoalWritingVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/15.
//

import UIKit

import SnapKit

class GoalWritingVC: UIViewController {
    
    // MARK: - Properties
    
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let whenLabel = UILabel()
    private let whenExLabel = UILabel()
    private let goalLabel = UILabel()
    private let goalExLabel = UILabel()
    private let whenTextField = UITextField()
    private let whenLineView = UIView()
    private let whenCountLabel = UILabel()
    private let goalTextField = UITextField()
    private let goalLineView = UIView()
    private let goalCountLabel = UILabel()
    private let completeButton = UIButton()
    private let maxLength: Int = 15
    
    var titleText: String?
    var roomId: Int?
    var moment: String?
    var purpose: String?
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setNotification()
        setAddTarget()
        setInitTextField(textField: whenTextField, countLabel: whenCountLabel, lineView: whenLineView)
        setInitTextField(textField: goalTextField, countLabel: goalCountLabel, lineView: goalLineView)
    }
    
    // MARK: - Methods
    
    private func setUI() {
        closeButton.setImage(UIImage(named: "icQuit"), for: .normal)
        
        titleLabel.text = "나의 목표 작성"
        titleLabel.font = .h3Subtitle
        titleLabel.textColor = .sparkBlack
        
        subTitleLabel.text = "'\(titleText ?? "기본")' 습관방에서의 \n시간과 목표를 적어 보세요!"
        subTitleLabel.numberOfLines = 2
        subTitleLabel.font = .krRegularFont(ofSize: 18)
        subTitleLabel.textColor = .sparkDarkGray
        
        whenLabel.text = "언제 습관을 진행할 건가요?"
        whenLabel.font = .h2Title
        whenLabel.textColor = .sparkBlack
        
        whenExLabel.text = "ex. 잠자기 전 / 오후 5시"
        whenExLabel.font = .p2Subtitle
        whenExLabel.textColor = .sparkDarkGray
        
        goalLabel.text = "나만의 목표는 무엇인가요?"
        goalLabel.font = .h2Title
        goalLabel.textColor = .sparkBlack
        
        goalExLabel.text = "ex. 포기하지 말자 / 하루에 1페이지씩"
        goalExLabel.font = .p2Subtitle
        goalExLabel.textColor = .sparkDarkGray
        
        completeButton.layer.cornerRadius = 2
        completeButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        completeButton.setTitle("작성 완료", for: .normal)
        completeButton.backgroundColor = .sparkGray
        completeButton.isEnabled = false
        
        whenTextField.text = "\(moment ?? "")"
        whenTextField.borderStyle = .none
        whenTextField.delegate = self
        whenTextField.tintColor = .sparkPinkred
        whenLineView.backgroundColor = .sparkGray
        whenCountLabel.text = "0/15"
        whenCountLabel.font = .p2SubtitleEng
        whenCountLabel.textColor = .sparkDarkGray
        
        goalTextField.text = "\(purpose ?? "")"
        goalTextField.borderStyle = .none
        goalTextField.delegate = self
        goalTextField.tintColor = .sparkPinkred
        goalLineView.backgroundColor = .sparkGray
        goalCountLabel.text = "0/15"
        goalCountLabel.font = .p2SubtitleEng
        goalCountLabel.textColor = .sparkDarkGray
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func setAddTarget() {
        completeButton.addTarget(self, action: #selector(touchCompleteButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(touchCloseButton), for: .touchUpInside)
    }
    
    private func ableButton() {
        completeButton.backgroundColor = .sparkPinkred
        completeButton.isEnabled = true
    }

    private func disableButton() {
        completeButton.backgroundColor = .sparkGray
        completeButton.isEnabled = false
    }
    
    private func upAnimation() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.subTitleLabel.alpha = 0
            
            let frame = CGAffineTransform(translationX: 0, y: UIScreen.main.hasNotch ? -118 : -98)
            [self.whenLabel, self.whenExLabel, self.whenLineView, self.whenTextField, self.whenCountLabel,
             self.goalLabel, self.goalExLabel, self.goalLineView, self.goalTextField, self.goalCountLabel].forEach { $0.transform = frame }
        }
    }
    
    private func downAnimation() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.subTitleLabel.alpha = 1.0
            
            let frame = CGAffineTransform(translationX: 0, y: 0)
            [self.whenLabel, self.whenExLabel, self.whenLineView, self.whenTextField, self.whenCountLabel,
             self.goalLabel, self.goalExLabel, self.goalLineView, self.goalTextField, self.goalCountLabel].forEach { $0.transform = frame }
        }
    }
    
    private func setInitTextField(textField: UITextField, countLabel: UILabel, lineView: UIView) {
        if textField.hasText {
            countLabel.text = "\(String(describing: textField.text?.count ?? 0))/15"
            
            let attributedString = NSMutableAttributedString(string: countLabel.text ?? "")
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.sparkPinkred, range: ((countLabel.text ?? "") as NSString).range(of: "\(String(describing: textField.text?.count ?? 0))"))
            
            countLabel.textColor = .sparkDarkGray
            countLabel.attributedText = attributedString
            lineView.backgroundColor = .sparkPinkred
            
            ableButton()
        }
    }
    
    @objc
    private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            switch textField {
            case whenTextField:
                self.changeCountLabel(textField: whenTextField, maxLength: 15, countLabel: whenCountLabel, lineView: whenLineView)
            case goalTextField:
                self.changeCountLabel(textField: goalTextField, maxLength: 15, countLabel: goalCountLabel, lineView: goalLineView)
            default:
                return
            }
        }
    }
    
    // MARK: - 화면전환
    @objc
    func touchCompleteButton() {
        setPurposeWithAPI(moment: whenTextField.text ?? "", purpose: goalTextField.text ?? "")
    }
    
    @objc
    func touchCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Network

extension GoalWritingVC {
    func setPurposeWithAPI(moment: String, purpose: String) {
        RoomAPI.shared.setPurpose(roomID: roomId ?? 0, moment: moment, purpose: purpose) { response in
            switch response {
            case .success(let message):
                print("setPurposeWithAPI - success: \(message)")
                self.dismiss(animated: true, completion: nil)
            case .requestErr(let message):
                print("setPurposeWithAPI - requestErr: \(message)")
            case .pathErr:
                print("setPurposeWithAPI - pathErr")
            case .serverErr:
                print("setPurposeWithAPI - serverErr")
            case .networkFail:
                print("setPurposeWithAPI - networkFail")
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension GoalWritingVC: UITextFieldDelegate {
    // 여백 클릭 시
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        downAnimation()
        self.view.endEditing(true)
    }

    // 리턴 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        downAnimation()
        self.view.endEditing(true)
        return true
    }
    
    // 입력 시작
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case whenTextField:
            whenLineView.backgroundColor = .sparkPinkred
        case goalTextField:
            goalLineView.backgroundColor = .sparkPinkred
        default:
            goalLineView.backgroundColor = .sparkPinkred
        }
        upAnimation()
        return true
    }
    
    // 입력 끝
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트필드에 따라 lineView 색상 각각 처리
        switch textField {
        case whenTextField:
            if whenTextField.hasText {
                whenLineView.backgroundColor = .sparkPinkred
            } else {
                whenLineView.backgroundColor = .sparkGray
            }
        case goalTextField:
            if goalTextField.hasText {
                goalLineView.backgroundColor = .sparkPinkred
            } else {
                goalLineView.backgroundColor = .sparkGray
            }
        default:
            return
        }
        
        // 하단 버튼 색상 처리
        if whenTextField.hasText && goalTextField.hasText {
            ableButton()
        } else {
            disableButton()
        }
    }
}

// MARK: - Layout
extension GoalWritingVC {
    private func setLayout() {
        view.addSubviews([closeButton, titleLabel, subTitleLabel,
                          whenLabel, whenExLabel,
                          goalLabel, goalExLabel, whenTextField,
                          whenLineView, whenCountLabel, goalTextField,
                          goalLineView, goalCountLabel, completeButton])
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 40 :30)
            make.leading.equalToSuperview().inset(20)
        }
        
        whenLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 72 : 50)
            make.leading.equalToSuperview().inset(20)
        }
        
        whenExLabel.snp.makeConstraints { make in
            make.top.equalTo(whenLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(20)
        }
        
        whenTextField.snp.makeConstraints { make in
            make.top.equalTo(whenExLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(28)
            make.width.equalTo(290)
            make.height.equalTo(46)
        }
        
        whenCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(whenTextField.snp.centerY)
            make.trailing.equalToSuperview().inset(28)
        }
        
        whenLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(whenTextField.snp.bottom)
            make.height.equalTo(2)
        }
        
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(whenLineView.snp.bottom).offset(UIScreen.main.hasNotch ? 96 : 66)
            make.leading.equalToSuperview().inset(20)
        }
        
        goalExLabel.snp.makeConstraints { make in
            make.top.equalTo(goalLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(20)
        }
        
        goalTextField.snp.makeConstraints { make in
            make.top.equalTo(goalExLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(28)
            make.width.equalTo(290)
            make.height.equalTo(46)
        }
        
        goalCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(goalTextField.snp.centerY)
            make.trailing.equalToSuperview().inset(28)
        }
        
        goalLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(goalTextField.snp.bottom)
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
