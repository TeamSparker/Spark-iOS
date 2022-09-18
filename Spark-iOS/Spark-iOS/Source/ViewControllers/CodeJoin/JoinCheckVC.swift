//
//  JoinCheckVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/14.
//

import UIKit
import Lottie

class JoinCheckVC: UIViewController {

    // MARK: - Properties
    
    lazy var ticketView: AnimationView = {
        let animationView = AnimationView(name: Const.Lottie.Name.ticketWelcome)
        animationView.frame = animationFrameView.bounds
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        return animationView
    }()
    
    var roomID: Int?
    var creatorName: String?
    var roomName: String?
    
    // MARK: - @IBOutlet Properties

    @IBOutlet weak var reInputButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var userInviteLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var animationFrameView: UIView!
    @IBOutlet weak var ticketImageView: UIImageView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAnimation()
        setLayout()
        setNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserver()
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func touchReinputCode(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func touchEnterWaitingVC(_ sender: Any) {
        enterRoomWithAPI(roomID: roomID ?? 0)
    }
    
    @IBAction func touchCloseButton(_ sender: Any) {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Methods

extension JoinCheckVC {
    private func setUI() {
        reInputButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        reInputButton.layer.borderColor = UIColor.sparkDarkPinkred.cgColor
        reInputButton.layer.borderWidth = 2
        
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.setTitleColor(.white, for: .selected)
        enterButton.setTitleColor(.sparkGray, for: .highlighted)
        enterButton.backgroundColor = .sparkDarkPinkred
        enterButton.titleLabel?.font = .btn1Default
        enterButton.layer.borderWidth = 0
        
        roomNameLabel.text = roomName
        userInviteLabel.text = creatorName
    }
    
    private func setAnimation() {
        animationFrameView.addSubview(ticketView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [self] in
            ticketView.play()
        }
    }
    
    private func setLayout() {
        reInputButton.snp.makeConstraints { make in
            make.height.equalTo(self.view.frame.width*48/335)
        }
        
        enterButton.snp.makeConstraints { make in
            make.height.equalTo(self.view.frame.width*48/335)
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissToHomeVC), name: .pushNotificationTapped, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .pushNotificationTapped, object: nil)
    }
    
    // MARK: - @objc
    
    @objc
    private func dismissToHomeVC() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: Network

extension JoinCheckVC {
    func enterRoomWithAPI(roomID: Int) {
        RoomAPI(viewController: self).enterRoom(roomID: roomID) {  response in
            switch response {
            case .success(let message):
                let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.waiting, bundle: nil)
                
                guard let rootViewController = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.waiting) as? WaitingVC else {return}
                rootViewController.roomId = roomID
                rootViewController.fromWhereStatus = .joinCode
                rootViewController.roomName = self.roomName
                
                let nextVC = UINavigationController(rootViewController: rootViewController)
                nextVC.modalPresentationStyle = .fullScreen
                nextVC.modalTransitionStyle = .crossDissolve
                
                self.present(nextVC, animated: true, completion: nil)
                print("enterRoomWithAPI - success: \(message)")
            case .requestErr(let message):
                print("enterRoomWithAPI - requestErr: \(message)")
            case .pathErr:
                print("enterRoomWithAPI - pathErr")
            case .serverErr:
                print("enterRoomWithAPI - serverErr")
            case .networkFail:
                print("enterRoomWithAPI - networkFail")
            }
        }
    }
}
