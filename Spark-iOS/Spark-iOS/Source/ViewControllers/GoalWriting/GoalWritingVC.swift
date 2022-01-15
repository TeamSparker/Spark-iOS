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
    
    let subTitleLabel = UILabel()
    let whenLabel = UILabel()
    let whenExLabel = UILabel()
    let goalLabel = UILabel()
    let goalExLabel = UILabel()
    let whenTextField = UITextField()
    let whenLineView = UIView()
    let whenCountLabel = UILabel()
    let goalTextField = UITextField()
    let goalLineView = UIView()
    let goalCountLabel = UILabel()
    let completeButton = UIButton()
    var titleText = "아침독서"
    var maxLength: Int = 15
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        subTitleLabel.text = "\(titleText) 습관방의 \n시간과 목표를 적어봐요."
        subTitleLabel.numberOfLines = 2
        subTitleLabel.font = .krRegularFont(ofSize: 18)
        subTitleLabel.textColor = .sparkDarkGray
        
        whenLabel.text = "언제 습관을 진행할 건가요?"
        whenLabel.font = .h2Title
        whenLabel.textColor = .sparkBlack
        
        whenExLabel.text = "ex. 잠자기 전 / 오후 5시"
        whenExLabel.font = .p2Subtitle
        whenExLabel.textColor = .sparkDarkGray
        
        goalLabel.text = "이 방에서 나만의 목표는 무엇인가요?"
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
        
        whenTextField.borderStyle = .none
        whenTextField.delegate = self
        whenLineView.backgroundColor = .sparkGray
        whenCountLabel.text = "0/15"
        whenCountLabel.font = .p2SubtitleEng
        whenCountLabel.textColor = .sparkDarkGray
        
        goalTextField.borderStyle = .none
        goalTextField.delegate = self
        goalLineView.backgroundColor = .sparkGray
        goalCountLabel.text = "0/15"
        goalCountLabel.font = .p2SubtitleEng
        goalCountLabel.textColor = .sparkDarkGray
    }
    
    private func setLayout() {
        view.addSubviews([subTitleLabel, whenLabel, whenExLabel,
                          goalLabel, goalExLabel, whenTextField,
                          whenLineView, whenCountLabel, goalTextField,
                          goalLineView, goalCountLabel, completeButton])
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        whenLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(72)
            make.leading.equalToSuperview().inset(20)
        }
        
        whenExLabel.snp.makeConstraints { make in
            make.top.equalTo(whenLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(20)
        }
        
        whenTextField.snp.makeConstraints { make in
            make.top.equalTo(whenExLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
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
            make.top.equalTo(whenLineView.snp.bottom).offset(96)
            make.leading.equalToSuperview().inset(20)
        }
        
        goalExLabel.snp.makeConstraints { make in
            make.top.equalTo(goalLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(20)
        }
        
        goalTextField.snp.makeConstraints { make in
            make.top.equalTo(goalExLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(self.view.frame.width*48/335)
        }
    }
    
//    private func ableButton() {
//        whenLineView.backgroundColor = .sparkPinkred
//        nextButton.backgroundColor = .sparkPinkred
//        nextButton.isEnabled = true
//    }
//
//    private func disableButton() {
//        lineView.backgroundColor = .sparkGray
//        nextButton.backgroundColor = .sparkGray
//        nextButton.isEnabled = false
//    }
}

extension GoalWritingVC: UITextFieldDelegate {
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
//        ableButton()
        return true
    }
    
    /// 입력 끝
    func textFieldDidEndEditing(_ textField: UITextField) {
        if whenTextField.hasText && goalTextField.hasText {
//            ableButton()
        } else {
//            disableButton()
        }
    }
}
