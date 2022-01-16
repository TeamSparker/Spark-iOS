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
        let animationView = AnimationView(name: "ticket_welcome")
        animationView.frame = animationFrameView.bounds
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .repeat(100)
        return animationView
    }()
    
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
    }
    
    // MARK: - @IBAction Properties
    // TODO: - 코드 다시 입력하기 기능 구현
    
    @IBAction func touchReinputCode(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func touchEnterWaitingVC(_ sender: Any) {
        let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.waiting, bundle: nil)
        
        guard let rootViewController = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.waiting) as? WaitingVC else {return}
        
        let nextVC = UINavigationController(rootViewController: rootViewController)
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
}

// MARK: - Methods

extension JoinCheckVC {
    private func setUI() {
        reInputButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        reInputButton.layer.borderColor = UIColor.sparkLightPinkred.cgColor
        reInputButton.layer.borderWidth = 2
        
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.setTitleColor(.white, for: .selected)
        enterButton.setTitleColor(.sparkGray, for: .highlighted)
        enterButton.backgroundColor = .sparkDarkPinkred
        enterButton.titleLabel?.font = .btn1Default
        enterButton.layer.borderWidth = 0
    }
    
    private func setAnimation() {
        animationFrameView.addSubview(ticketView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [self] in
            ticketView.play()
        }
    }
}
