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
    
    // MARK: - Methods
    func setUI() {
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
    
    func setAddTargets() {
        okButton.addTarget(self, action: #selector(touchOkayButton), for:. touchUpInside)
    }
    
    func setDelegate() {
        textField.delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
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
        let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.joinCheck, bundle:nil)
        
        guard let nextVC = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.joinCheck) as? JoinCheckVC else {return}
        
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    
    // MARK: - @IBAction Properties
    @IBAction func touchOutsideButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - textField Delegate
extension CodeJoinVC: UITextFieldDelegate {
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

// MARK: - Network > 네트워크 목적을 가진 함수들
