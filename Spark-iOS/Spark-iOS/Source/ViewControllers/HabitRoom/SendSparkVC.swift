//
//  SendSparkVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/18.
//

import UIKit

class SendSparkVC: UIViewController {

    // MARK: Properties

    var roomID: Int?
    var recordID: Int?
    var userName: String?
    var profileImage: String?
    private var maxLength: Int = 15
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?

    private let customNavigationBar = LeftButtonNavigaitonBar()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 64/2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.sparkLightGray.cgColor
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .h3Subtitle
        label.textColor = .sparkLightGray
        return label
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.textColor = .sparkWhite
        tf.keyboardAppearance = .default
        tf.tintColor = .sparkPinkred
        tf.backgroundColor = .clear
        tf.attributedPlaceholder = NSAttributedString(string: "15자 이내의 응원 메시지를 보내보세요!",
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.sparkDarkGray.cgColor])
        tf.returnKeyType = .send
        tf.isHidden = true
        return tf
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("보내기", for: .normal)
        button.tintColor = .sparkPinkred
        button.titleLabel?.font = .p1Title
        button.setTitleColor(.sparkGray, for: .disabled)
        button.isHidden = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(sendSparkWithMessage), for: .touchUpInside)
        return button
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .sparkPinkred
        return view
    }()
    
    private var buttonCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 124, height: 124)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.font = .p1TitleLight
        label.textColor = .sparkGray
        label.text = "메시지 선택 시 바로 보낼 수 있어요!"
        return label
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCollectionView()
        setLayout()
        setDelegate()
        setAddTargets()
        setNotification()
    }
}

// MARK: Methods

extension SendSparkVC {
    private func setUI() {
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.9)
        
        customNavigationBar.title("스파크 보내기")
            .titleColor(.sparkWhite)
            .backgroundColor(.clear)
            .tintColor(.sparkWhite)
            .leftButtonImage("icQuit")
            .leftButonAction {
                self.dismiss(animated: true, completion: nil)
                self.removeObservers()
            }
        
        profileImageView.updateImage(profileImage ?? "")
        
        userNameLabel.text = "\(userName ?? "")에게"
    }
    
    private func setCollectionView() {
        buttonCV.delegate = self
        buttonCV.dataSource = self
        buttonCV.register(SendSparkCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.sendSparkCVC)
    }
    
    private func setDelegate() {
        textField.delegate = self
    }
    
    private func setFeedbackGenerator() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.selectionChanged()
    }
    
    private func setAddTargets() {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - @objc Function
    @objc
    private func sendSparkWithMessage() {
        sendSparkWithAPI(content: textField.text ?? "")
    }
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        if let text = sender.text {
            if text.count >= maxLength {
                let maxIndex = text.index(text.startIndex, offsetBy: maxLength)
                let newString = String(text[text.startIndex..<maxIndex])
                textField.text = newString
                sendButton.titleLabel?.textColor = .sparkPinkred
                sendButton.isEnabled = true
            } else if (0 < text.count)&&(text.count < maxLength) {
                sendButton.titleLabel?.textColor = .sparkPinkred
                sendButton.isEnabled = true
            } else {
                sendButton.titleLabel?.textColor = .sparkGray
                sendButton.isEnabled = false
            }
        }
    }
    
    @objc func keyBoardWillShow(_ notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let lineViewHeight: CGFloat = 2
            let targetY: CGFloat = screenHeight - keyboardHeight - 20 - lineViewHeight
            
            sendButton.snp.makeConstraints { make in
                make.trailing.equalTo(lineView.snp.trailing).inset(2.5)
                make.bottom.equalTo(lineView.snp.top).offset(-4)
            }
            
            lineView.snp.makeConstraints { make in
                make.height.equalTo(2)
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalToSuperview().inset(targetY)
            }
            
            textField.snp.makeConstraints { make in
                make.leading.equalTo(lineView.snp.leading).offset(8)
                make.bottom.equalTo(lineView.snp.top).offset(-10)
            }
        }
    }
}

// MARK: - Animation Methods

extension SendSparkVC {
    private func showAnimation() {
        [textField, lineView, sendButton].forEach {
            $0.isHidden = false
            $0.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.textField.alpha = 1
            self.lineView.alpha = 1
            self.sendButton.alpha = 1
        }
    }
    
    private func hideAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.textField.alpha = 0
            self.lineView.alpha = 0
            self.sendButton.alpha = 0
        } completion: { _ in
            [self.textField, self.lineView, self.sendButton].forEach {
                $0.isHidden = true
            }
        }
    }
}

// MARK: - SendSparkCellDelegate

extension SendSparkVC: SendSparkCellDelegate {
    func sendSpark(_ content: String) {
        sendSparkWithAPI(content: content)
    }
    func showTextField() {
        showAnimation()
        textField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension SendSparkVC: UITextFieldDelegate {
    // 여백 클릭 시
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideAnimation()
        self.view.endEditing(true)
    }
    
    // 리턴 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            sendSparkWithAPI(content: text)
        }
        hideAnimation()
        self.view.endEditing(true)
        return true
    }
    
    // 입력 끝
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.hasText {
            sendButton.isEnabled = false
            sendButton.titleLabel?.textColor = .sparkGray
        }
    }
}
// MARK: - UICollectionViewDataSource

extension SendSparkVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.sendSparkCVC, for: indexPath) as? SendSparkCVC else { return UICollectionViewCell() }
        
        cell.setSparkButton(type: SendSparkStatus.init(rawValue: indexPath.row) ?? .message)
        cell.sendSparkCellDelegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SendSparkVC: UICollectionViewDelegate {

}

// MARK: Network

extension SendSparkVC {
    func sendSparkWithAPI(content: String) {
        RoomAPI.shared.sendSpark(roomID: roomID ?? 0, recordID: recordID ?? 0, content: content) {  response in
            switch response {
            case .success:
                let presentVC = self.presentingViewController
                self.dismiss(animated: true) {
                    presentVC?.showSparkToast(x: 20, y: 44, message: "\(self.userName ?? "")에게 스파크를 보냈어요!")
                }
            case .requestErr(let message):
                print("sendSparkWithAPI - requestErr: \(message)")
            case .pathErr:
                print("sendSparkWithAPI - pathErr")
            case .serverErr:
                print("sendSparkWithAPI - serverErr")
            case .networkFail:
                print("sendSparkWithAPI - networkFail")
            }
        }
    }
}

// MARK: - Layout

extension SendSparkVC {
    private func setLayout() {
        view.addSubviews([customNavigationBar, profileImageView, userNameLabel,
                          textField, sendButton, lineView,
                          buttonCV, guideLabel])
        
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.bottom.equalTo(userNameLabel.snp.top).offset(-12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(buttonCV.snp.top).offset(-200)
            make.centerX.equalToSuperview()
        }
        
        buttonCV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(87)
            make.height.equalTo(124)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(44)
            make.centerX.equalToSuperview()
        }
    }
}
