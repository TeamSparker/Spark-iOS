//
//  HabitRoomLeaveVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/02/27.
//

import UIKit

class HabitRoomLeaveVC: UIViewController {
    
    // MARK: - Properties
    
    private let popupView = UIView()
    private let guideLabel = UILabel()
    private let textField = UITextField()
    private let lineView = UIView()
    private let horizonLineView = UIView()
    private let verticalLineView = UIView()
    private let cancelButton = UIButton()
    private let leaveButton = UIButton()
    
    var roomName: String = ""
    var closure: (() -> Void)?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }
    
    // MARK: - Custom Method
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        popupView.backgroundColor = .sparkWhite
        popupView.layer.cornerRadius = 2
        
        guideLabel.text = "방에서 나가면 미완료 처리됩니다.\n확인을 위해 ‘방 이름’을 입력해 주세요."
        guideLabel.textAlignment = .center
        guideLabel.textColor = .sparkBlack
        guideLabel.font = .p1TitleLight
        guideLabel.numberOfLines = 2
        
        textField.delegate = self
        textField.borderStyle = .none
        textField.placeholder = roomName
        textField.textAlignment = .center
        textField.tintColor = .sparkPinkred
        lineView.backgroundColor = .sparkGray
        
        horizonLineView.backgroundColor = .sparkLightGray
        verticalLineView.backgroundColor = .sparkLightGray
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.sparkDarkGray, for: .normal)
        cancelButton.titleLabel?.font = .krMediumFont(ofSize: 16)
        
        leaveButton.setTitle("나가기", for: .normal)
        leaveButton.setTitleColor(.sparkDarkGray, for: .disabled)
        leaveButton.titleLabel?.font = .krMediumFont(ofSize: 16)
        leaveButton.isEnabled = false
    }
    
    private func setAddTarget() {
        cancelButton.addTarget(self, action: #selector(dismissHabitRoomLeaveVC), for: .touchUpInside)
        leaveButton.addTarget(self, action: #selector(touchLeaveButton), for: .touchUpInside)
    }
    
    private func ableButton() {
        leaveButton.isEnabled = true
        leaveButton.setTitleColor(.sparkDarkPinkred, for: .normal)
    }
    
    private func unableButotn() {
        leaveButton.isEnabled = false
        leaveButton.setTitleColor(.sparkDarkGray, for: .disabled)
    }
    
    // MARK: - @objc
    @objc
    func dismissHabitRoomLeaveVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func touchLeaveButton() {
        self.dismiss(animated: true) {
            self.closure?()
        }
    }
}

// MARK: - UITextFieldDelegate
extension HabitRoomLeaveVC: UITextFieldDelegate {
    // 여백 클릭 시
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 리턴 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // textField 값이 변경될 때마다 감지
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == roomName {
            ableButton()
        } else {
            unableButotn()
        }
    }
    
    // 입력 시작
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = ""
        lineView.backgroundColor = .sparkPinkred
        return true
    }
    
    // 입력 끝
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText {
            if textField.text == roomName {
                ableButton()
            } else {
                unableButotn()
            }
            lineView.backgroundColor = .sparkPinkred
        } else {
            textField.placeholder = roomName
            unableButotn()
            lineView.backgroundColor = .sparkGray
        }
    }
}

// MARK: - Layout

extension HabitRoomLeaveVC {
    private func setLayout() {
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo((UIScreen.main.bounds.width - 40) * 214 / 335)
        }
        
        popupView.addSubviews([guideLabel, textField, lineView,
                               horizonLineView, verticalLineView, cancelButton, leaveButton])
        
        guideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(25)
        }
        
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(60)
            make.top.equalTo(horizonLineView.snp.top).offset(-32)
            make.height.equalTo(2)
        }
        
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(lineView.snp.top)
            make.height.equalTo(39)
        }
        
        horizonLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(47)
            make.height.equalTo(1)
        }
        
        verticalLineView.snp.makeConstraints { make in
            make.top.equalTo(horizonLineView.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(horizonLineView.snp.bottom)
            make.trailing.equalTo(verticalLineView.snp.leading)
        }
        
        leaveButton.snp.makeConstraints { make in
            make.leading.equalTo(verticalLineView.snp.trailing)
            make.top.equalTo(horizonLineView.snp.bottom)
            make.trailing.bottom.equalToSuperview()
        }
    }
}
