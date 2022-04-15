//
//  HabitAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit
import AVFoundation

@frozen
enum AuthType {
    case photoOnly
    case photoTimer
}

class HabitAuthVC: UIViewController {

    // MARK: - Properties
    
    var authType: AuthType?
    var roomID: Int?
    var restNumber: Int?
    var roomName: String?
    var presentAlertClosure: (() -> Void)?
    var restStatus: String?
    
    @frozen
    private enum Status: String {
        case none = "NONE"
        case consider = "CONSIDER"
        case done = "DONE"
        case rest = "REST"
    }
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var considerButton: UIButton!
    @IBOutlet weak var restButton: UIButton!
    @IBOutlet weak var authTypeImageView: UIImageView!
    @IBOutlet weak var restNumberLabel: UILabel!
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAddTargets()
        setLayout()
    }
    
    @IBAction func touchOutsideDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Methods
extension HabitAuthVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)

        switch authType {
        case .photoOnly:
            authTypeImageView.image = UIImage(named: "stickerPhotoDefault")
        case .photoTimer:
            authTypeImageView.image = UIImage(named: "stickersBoth")
        case .none:
            print("authType을 지정해주세요")
        }
        
        popUpView.layer.cornerRadius = 2
        
        okButton.layer.cornerRadius = 2
        okButton.layer.borderWidth = 1
        okButton.titleLabel?.text = "지금 습관 인증하기"
        okButton.tintColor = .sparkGray
        
        guard let restStatus = restStatus, let status = Status(rawValue: restStatus) else { return }
        switch status {
        case .none:
            okButton.isEnabled = true
            okButton.setTitleColor(.sparkWhite, for: .normal)
            okButton.layer.borderColor = UIColor.sparkDarkPinkred.cgColor
            okButton.backgroundColor = .sparkDarkPinkred
            
            considerButton.isEnabled = true
            considerButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
            considerButton.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        case .consider:
            okButton.isEnabled = true
            okButton.setTitleColor(.sparkWhite, for: .normal)
            okButton.layer.borderColor = UIColor.sparkDarkPinkred.cgColor
            okButton.backgroundColor = .sparkDarkPinkred
            
            considerButton.isEnabled = false
            considerButton.layer.borderColor = UIColor.sparkGray.cgColor
            considerButton.setTitleColor(.sparkGray, for: .disabled)
        case .rest:
            return
        case .done:
            return
        }
        
        considerButton.layer.borderWidth = 1
        considerButton.layer.cornerRadius = 2
        
        restButton.layer.borderWidth = 1
        restButton.layer.cornerRadius = 2
        
        restNumberLabel.text = String(restNumber ?? 0)
        
        if restNumber == 0 {
            restButton.isEnabled = false
            restButton.layer.borderColor = UIColor.sparkGray.cgColor
            restButton.setTitleColor(.sparkGray, for: .disabled)
        } else {
            restButton.isEnabled = true
            restButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
            restButton.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        }
    }
    
    private func setLayout() {
        okButton.snp.makeConstraints { make in
            make.height.equalTo(self.view.frame.width*48/335)
        }
    }
    
    private func setAddTargets() {
        okButton.addTarget(self, action: #selector(touchOkayButton), for: .touchUpInside)
        considerButton.addTarget(self, action: #selector(touchConsiderButton), for: .touchUpInside)
        restButton.addTarget(self, action: #selector(touchRestButton), for: .touchUpInside)
    }
    
    @objc
    private func touchOkayButton() {
        let presentingVC = self.presentingViewController
        switch authType {
        case .photoOnly:
            self.dismiss(animated: true) {
                self.presentAlertClosure?()
            }
        case .photoTimer:
            self.dismiss(animated: true) {
                guard let rootVC = UIStoryboard(name: Const.Storyboard.Name.authTimer, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.authTimer) as? AuthTimerVC else { return }
                let nextVC = UINavigationController(rootViewController: rootVC)
                nextVC.modalPresentationStyle = .fullScreen
                rootVC.roomId = self.roomID
                rootVC.roomName = self.roomName
                
                presentingVC?.present(nextVC, animated: true, completion: nil)
            }
        default:
            print("아닙니다")
        }
    }
    
    @objc
    private func touchConsiderButton() {
        self.dismiss(animated: true) {
            self.setConsiderRestWithAPI(statusType: "CONSIDER")
        }
    }
    
    @objc
    private func touchRestButton() {
        let presentingVC = presentingViewController
        dismiss(animated: true) {
            guard let dialogueVC = UIStoryboard(name: Const.Storyboard.Name.dialogue, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.dialogue) as? DialogueVC else { return }
            
            dialogueVC.dialogueType = .rest
            dialogueVC.clousure = {
                self.setConsiderRestWithAPI(statusType: "REST")
            }
            dialogueVC.modalTransitionStyle = .crossDissolve
            dialogueVC.modalPresentationStyle = .overFullScreen
            
            presentingVC?.present(dialogueVC, animated: true, completion: nil)
        }
    }
}

// MARK: Network

extension HabitAuthVC {
    func setConsiderRestWithAPI(statusType: String) {
        RoomAPI(viewController: self).setConsiderRest(roomID: roomID ?? 0, statusType: statusType) {  response in
            switch response {
            case .success(let message):
                NotificationCenter.default.post(name: .updateHabitRoom, object: nil)
                print("setConsiderRestWithAPI - success: \(message)")
            case .requestErr(let message):
                print("setConsiderRestWithAPI - requestErr: \(message)")
            case .pathErr:
                print("setConsiderRestWithAPI - pathErr")
            case .serverErr:
                print("setConsiderRestWithAPI - serverErr")
            case .networkFail:
                print("setConsiderRestWithAPI - networkFail")
            }
        }
    }
}
