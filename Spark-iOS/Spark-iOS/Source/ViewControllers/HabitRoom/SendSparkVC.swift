//
//  SendSparkVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/18.
//

import UIKit

class SendSparkVC: UIViewController {

    // MARK: Properties
    var selectedMessage: String = ""
    var roomID: Int?
    var recordID: Int?
    var firstButton = StatusButton()
    var secondButton = StatusButton()
    var thirdButton = StatusButton()
    var fourthButton = StatusButton()
    var userName: String?
    
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
            $0.tintColor = .sparkLightPinkred
            $0.layer.borderColor = UIColor.sparkLightPinkred.cgColor
            $0.layer.cornerRadius = 2
            $0.layer.borderWidth = 1
            $0.setTitleColor(.sparkLightPinkred, for: .normal)
        }
        
        firstButton.setTitle("👊 아자아자 파이팅!", for: .normal)
        secondButton.setTitle("🔥오늘 안 해? 같이 해!", for: .normal)
        thirdButton.setTitle("👉 너만 하면 돼!", for: .normal)
        fourthButton.setTitle("👍 얼마 안 남았어, 어서 하자!", for: .normal)
        
        firstButton.status = 1
        secondButton.status = 2
        thirdButton.status = 3
        fourthButton.status = 4
    }
    
    private func setLayout() {
        view.addSubviews([firstButton, secondButton, thirdButton, fourthButton])
        
        firstButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(guideLabel.snp.bottom).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(170)
        }
        
        secondButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstButton.snp.bottom).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(186)
        }
        
        thirdButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondButton.snp.bottom).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(147)
        }
        
        fourthButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(thirdButton.snp.bottom).offset(20)
            make.height.equalTo(36)
            make.width.equalTo(230)
        }
    }
    
    // 버튼 타겟 설정
    private func setAddTargets(_ buttons: UIButton...) {
        for button in buttons {
            button.addTarget(self, action: #selector(setSelectedButton), for: .touchUpInside)
        }
    }
    
    // MARK: - @objc Function
    
    @objc
    func setSelectedButton(sender: StatusButton) {
        
        let status = sender.status
        
        sender.setTitleColor(.sparkDarkPinkred, for: .normal)
        sender.backgroundColor = .sparkMostLightPinkred
        sender.titleLabel?.backgroundColor = .sparkMostLightPinkred
        sender.layer.borderColor = UIColor.sparkDarkPinkred.cgColor
        
        selectedMessage = sender.titleLabel?.text ?? ""
        
        switch status {
        case 1:
            [firstButton, secondButton, thirdButton, fourthButton].forEach {
                if $0.status != 1 {
                    $0.tintColor = .sparkLightPinkred
                    $0.layer.borderColor = UIColor.sparkLightPinkred.cgColor
                    $0.setTitleColor(.sparkLightPinkred, for: .normal)
                    $0.backgroundColor = .sparkWhite
                    $0.titleLabel?.backgroundColor = .sparkWhite
                }
            }

        case 2:
            [firstButton, secondButton, thirdButton, fourthButton].forEach {
                if $0.status != 2 {
                    $0.tintColor = .sparkLightPinkred
                    $0.layer.borderColor = UIColor.sparkLightPinkred.cgColor
                    $0.setTitleColor(.sparkLightPinkred, for: .normal)
                    $0.backgroundColor = .sparkWhite
                    $0.titleLabel?.backgroundColor = .sparkWhite
                }
            }

        case 3:
            [firstButton, secondButton, thirdButton, fourthButton].forEach {
                if $0.status != 3 {
                    $0.tintColor = .sparkLightPinkred
                    $0.layer.borderColor = UIColor.sparkLightPinkred.cgColor
                    $0.setTitleColor(.sparkLightPinkred, for: .normal)
                    $0.backgroundColor = .sparkWhite
                    $0.titleLabel?.backgroundColor = .sparkWhite
                }
            }

        default:
            [firstButton, secondButton, thirdButton, fourthButton].forEach {
                if $0.status != 4 {
                    $0.tintColor = .sparkLightPinkred
                    $0.layer.borderColor = UIColor.sparkLightPinkred.cgColor
                    $0.setTitleColor(.sparkLightPinkred, for: .normal)
                    $0.backgroundColor = .sparkWhite
                    $0.titleLabel?.backgroundColor = .sparkWhite
                }
            }
        }
        
        sendSparkWithAPI()
    }
}

// MARK: Network

extension SendSparkVC {
    func sendSparkWithAPI() {
        RoomAPI.shared.sendSpark(roomID: roomID ?? 0, recordID: recordID ?? 0, content: selectedMessage) {  response in
            switch response {
            case .success(_):
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
