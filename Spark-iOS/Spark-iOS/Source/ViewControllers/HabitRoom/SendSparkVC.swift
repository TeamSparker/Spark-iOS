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
    
    private var firstButton = SendSparkButton()
    private var secondButton = SendSparkButton()
    private var thirdButton = SendSparkButton()
    private var fourthButton = SendSparkButton()
    
    private let firstButtonText: String = "👊 아자아자 파이팅!"
    private let secondButtonText: String = "🔥오늘 안 해? 같이 해!"
    private let thirdButtonText: String = "👉 너만 하면 돼!"
    private let fourthButtonText: String = "👍 얼마 안 남았어, 어서 하자!"
    
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    
    // MARK: IBoutlet properties
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var guideLabel: UILabel!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTargets(firstButton, secondButton, thirdButton, fourthButton)
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
        
        [firstButton, secondButton, thirdButton, fourthButton].forEach {
            $0.layer.borderColor = UIColor.sparkLightPinkred.cgColor
            $0.layer.cornerRadius = 2
            $0.layer.borderWidth = 1
            $0.setTitleColor(.sparkLightPinkred, for: .normal)
            $0.titleLabel?.font = .krMediumFont(ofSize: 14)
        }
        
        firstButton.setTitle(firstButtonText, for: .normal)
        secondButton.setTitle(secondButtonText, for: .normal)
        thirdButton.setTitle(thirdButtonText, for: .normal)
        fourthButton.setTitle(fourthButtonText, for: .normal)
        
        firstButton.identifier = 1
        secondButton.identifier = 2
        thirdButton.identifier = 3
        fourthButton.identifier = 4
    }
    
    private func setAddTargets(_ buttons: UIButton...) {
        for button in buttons {
            button.addTarget(self, action: #selector(setSelectedButton(_:)), for: .touchUpInside)
        }
    }
    
    private func setFeedbackGenerator() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.selectionChanged()
    }
    
    // MARK: - @objc Function
    
    @objc
    func setSelectedButton(_ sender: SendSparkButton) {
        [firstButton, secondButton, thirdButton, fourthButton].forEach {
            setFeedbackGenerator()
            
            if $0.identifier != sender.identifier {
                $0.setTitleColor(.sparkLightPinkred, for: .normal)
                $0.backgroundColor = .sparkWhite
                $0.titleLabel?.backgroundColor = .sparkWhite
                $0.layer.borderColor = UIColor.sparkLightPinkred.cgColor
            } else {
                $0.setTitleColor(.sparkDarkPinkred, for: .normal)
                $0.backgroundColor = .sparkMostLightPinkred
                $0.titleLabel?.backgroundColor = .sparkMostLightPinkred
                $0.layer.borderColor = UIColor.sparkDarkPinkred.cgColor
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
