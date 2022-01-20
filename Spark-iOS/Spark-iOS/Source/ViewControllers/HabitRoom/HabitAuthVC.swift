//
//  HabitAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit
import AVFoundation

@frozen enum AuthType {
    case photoOnly
    case photoTimer
}

class HabitAuthVC: UIViewController {

    // MARK: - Properties
    
    var authType: AuthType?
    var roomID: Int?
    var rest: Int?
    var roomName: String?
    var presentAlertClosure: (() -> Void)?
    
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
    }
    
    @IBAction func touchOutsideDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Methods
extension HabitAuthVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        switch authType {
        case .photoOnly:
            authTypeImageView.image = UIImage(named: "stickerPhotoDefault")
        case .photoTimer:
            authTypeImageView.image = UIImage(named: "stickersBoth")
        case .none:
            print("authType을 지정해주세요")
        }
        
        popUpView.layer.cornerRadius = 2
        
        okButton.isEnabled = true
        okButton.layer.cornerRadius = 2
        okButton.titleLabel?.text = "지금 습관 인증하기"
        okButton.backgroundColor = .sparkDarkPinkred
        okButton.tintColor = .sparkGray
        okButton.setTitleColor(.sparkGray, for: .highlighted)
        
        considerButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        considerButton.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        considerButton.layer.borderWidth = 1
        considerButton.layer.cornerRadius = 2
        
        restButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        restButton.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        restButton.layer.borderWidth = 1
        restButton.layer.cornerRadius = 2
//        if restNumber == 0 {
//            restButton.isEnabled = false
//        }
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
        setConsiderRestWithAPI(statusType: "CONSIDER")
    }
    
    @objc
    private func touchRestButton() {
        setConsiderRestWithAPI(statusType: "REST")
    }
}

// MARK: Network

extension HabitAuthVC {
    func setConsiderRestWithAPI(statusType: String) {
        RoomAPI.shared.setConsiderRest(roomID: roomID ?? 0, statusType: statusType) {  response in
            switch response {
            case .success(_):
                self.dismiss(animated: true, completion: nil)
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
