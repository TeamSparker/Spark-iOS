//
//  CodeJoinVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/14.
//

import UIKit

class CodeJoinVC: UIViewController {

    // MARK: - Properties
    
    var maxLength: Int = 7
    
    // MARK: - @IBOutlet Properties

    @IBOutlet weak var standardLine: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lineView: UIView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAddTargets()
        setNotification()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetUI()
        resetLayout()
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func touchOutsideButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - Methods

extension CodeJoinVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        popUpView.layer.cornerRadius = 2
        
        errorLabel.textColor = .sparkBrightPinkred
        errorLabel.font = .p2Subtitle
        errorLabel.isHidden = true
        
        okView.backgroundColor = .sparkGray
        okView.layer.cornerRadius = 2
        
        okButton.isEnabled = false
        okButton.titleLabel?.text = ""
        okButton.setTitleColor(.clear, for: .disabled)
    }
    
    private func setAddTargets() {
        okButton.addTarget(self, action: #selector(touchOkayButton), for: .touchUpInside)
    }
    
    private func setDelegate() {
        textField.delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func resetUI() {
        textField.text = ""
        lineView.backgroundColor = .sparkGray
        okView.backgroundColor = .sparkGray
        okButton.isEnabled = false
        errorLabel.isHidden = true
    }
    
    private func resetLayout() {
        if standardLine.frame.origin.y > popUpView.frame.origin.y {
            downAnimation()
        }
    }
    
    // MARK: - @objc Function
    @objc
    private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                /// 글자수 count 초과한 경우
                if text.count >= maxLength {
                    let maxIndex = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = String(text[text.startIndex..<maxIndex])
                    textField.text = newString
                    lineView.backgroundColor = .sparkPinkred
                    okView.backgroundColor = .sparkPinkred
                    okButton.isEnabled = true
                }
                /// 그 외 0인 경우
                else {
                    okView.backgroundColor = .sparkGray
                    okButton.isEnabled = false
                }
            }
        }
    }

    @objc func touchOkayButton() {
        codeJoinCheckFetchWithAPI()
    }
}

// MARK: - Animation

extension CodeJoinVC {
    private func upAnimation() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut) {
            
            let frame = CGAffineTransform(translationX: 0, y: -65)
            self.popUpView.transform = frame
            self.okButton.transform = frame
        }
    }
    
    private func downAnimation() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut) {
            
            let frame = CGAffineTransform(translationX: 0, y: 0)
            self.popUpView.transform = frame
            self.okButton.transform = frame
        }
    }
}

// MARK: - textField Delegate

extension CodeJoinVC: UITextFieldDelegate {
    /// 리턴 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        downAnimation()
        self.view.endEditing(true)
        return true
    }
    
    /// 입력 시작
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        upAnimation()
        lineView.backgroundColor = .sparkPinkred
        return true
    }
    
    /// 입력 끝
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText {
            lineView.backgroundColor = .sparkPinkred
        } else {
            lineView.backgroundColor = .sparkGray
        }
    }
}

// MARK: Network

extension CodeJoinVC {
    func codeJoinCheckFetchWithAPI() {
        RoomAPI.shared.codeJoinCheckFetch(code: textField.text ?? "") {  response in
            switch response {
            case .success(let data):
                if let codeWaiting = data as? CodeWaiting {
                    let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.joinCheck, bundle: nil)
                    guard let nextVC = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.joinCheck) as? JoinCheckVC else {return}
                    
                    nextVC.creatorName = "\(codeWaiting.creatorName)님이 초대한 방"
                    nextVC.roomName = codeWaiting.roomName
                    nextVC.roomID = codeWaiting.roomID

                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.modalTransitionStyle = .crossDissolve
                    self.present(nextVC, animated: false, completion: nil)
                }
            case .requestErr(let message):
                self.errorLabel.isHidden = false
                self.errorLabel.text = message as? String
                print("getCodeWaitingWithAPI - requestErr")
            case .pathErr:
                print("getCodeWaitingWithAPI - pathErr")
            case .serverErr:
                print("getCodeWaitingWithAPI - serverErr")
            case .networkFail:
                print("getCodeWaitingWithAPI - networkFail")
            }
        }
    }
}
