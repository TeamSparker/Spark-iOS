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
    
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let textField = UITextField()
    private let lineView = UIView()
    private let countLabel = UILabel()
    private let nextButton = UIButton()
    private let maxLength: Int = 15

    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setNotification()
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
        nextButton.setTitle("다음으로", for: .normal)
        nextButton.backgroundColor = .sparkGray
        nextButton.isEnabled = false
        
        textField.borderStyle = .none
        textField.placeholder = "ex. 30분 독서"
        textField.delegate = self
        textField.tintColor = .sparkPinkred

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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
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
            self.changeCountLabel(textField: textField, maxLength: maxLength, countLabel: countLabel, lineView: lineView)
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
            ableButton()
        } else {
            disableButton()
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
