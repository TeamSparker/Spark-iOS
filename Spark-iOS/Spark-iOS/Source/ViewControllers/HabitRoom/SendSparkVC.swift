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
    
    private var firstButton = SendSparkButton(type: .first)
    private var secondButton = SendSparkButton(type: .second)
    private var thirdButton = SendSparkButton(type: .third)
    private var fourthButton = SendSparkButton(type: .fourth)
    
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    
    // MARK: IBoutlet properties
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var guideLabel: UILabel!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTargets()
    }
    
    // MARK: IBAction Properties
    
    @IBAction func touchOutsideButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: Methods

extension SendSparkVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setAddTargets() {
        [firstButton, secondButton, thirdButton, fourthButton].forEach {
            $0.addTarget(self, action: #selector(touchSendSparkButton(_:)), for: .touchUpInside)
        }
    }
    
    private func setFeedbackGenerator() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.selectionChanged()
    }
    
    // MARK: - @objc Function
    
    @objc
    func touchSendSparkButton(_ sender: SendSparkButton) {
        setFeedbackGenerator()
        
        [firstButton, secondButton, thirdButton, fourthButton].forEach {
            if $0.tag == sender.tag {
                $0.isSelected(true)
            } else {
                // 통신실패 시에도 다시금 deselected 되야하니 필요함.
                $0.isSelected(false)
            }
        }
        let selectedMessage = sender.titleLabel?.text ?? ""
        sendSparkWithAPI(content: selectedMessage)
    }
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
        view.addSubviews([firstButton, secondButton, thirdButton, fourthButton])
        
        firstButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(guideLabel.snp.bottom).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(143)
        }
        
        secondButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstButton.snp.bottom).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(157)
        }
        
        thirdButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondButton.snp.bottom).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(120)
        }
        
        fourthButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(thirdButton.snp.bottom).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(200)
        }
    }
}
