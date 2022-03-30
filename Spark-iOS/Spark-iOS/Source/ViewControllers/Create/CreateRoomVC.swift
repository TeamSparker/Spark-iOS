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
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let textField = UITextField()
    private let lineView = UIView()
    private let countLabel = UILabel()
    private let nextButton = BottomButton().setUI(.pink).setTitle("다음으로").setDisable()
    private let customNavigationBar = LeftButtonNavigaitonBar()
    private let maxLength: Int = 15

    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setNotification()
        setAddTarget()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        customNavigationBar.title("")
            .leftButtonImage("icQuit")
            .leftButtonAction {
                self.dismissToHomeVC()
            }
        
        titleLabel.text = "어떤 습관방을 만들건가요?"
        titleLabel.font = .h2Title
        titleLabel.textColor = .sparkBlack
        
        subTitleLabel.text = "진행할 습관을 담아 방 이름을 \n설정해보세요!"
        subTitleLabel.numberOfLines = 2
        subTitleLabel.font = .krRegularFont(ofSize: 18)
        subTitleLabel.textColor = .sparkDarkGray
        
        lineView.backgroundColor = .sparkGray
        
        textField.borderStyle = .none
        textField.placeholder = "ex. 30분 독서"
        textField.delegate = self
        textField.tintColor = .sparkPinkred

        countLabel.text = "0/15"
        countLabel.font = .p2SubtitleEng
        countLabel.textColor = .sparkDarkGray
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func setAddTarget() {
        nextButton.addTarget(self, action: #selector(touchNextButton), for: .touchUpInside)
    }
    
    // MARK: - Screen Change

    private func dismissToHomeVC() {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - @objc
    
    @objc
    private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            self.changeCountLabel(textField: textField, maxLength: maxLength, countLabel: countLabel)
        }
    }
    
    @objc
    func touchNextButton() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.createAuth, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.createAuth) as? CreateAuthVC else { return }
        nextVC.roomName = textField.text ?? ""
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension CreateRoomVC: UITextFieldDelegate {
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
            nextButton.setAble()
            lineView.backgroundColor = .sparkPinkred
        } else {
            nextButton.setDisable()
            lineView.backgroundColor = .sparkGray
        }
    }
}

// MARK: - Layout
extension CreateRoomVC {
    private func setLayout() {
        view.addSubviews([customNavigationBar, titleLabel, subTitleLabel, textField,
                          lineView, countLabel, nextButton])
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(96)
            make.leading.equalToSuperview().inset(28)
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
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
// FIXME: - 네비게이션 extension 정리후 공통으로 빼서 사용하기
extension CreateRoomVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
