//
//  CompleteAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit
import Lottie

class CompleteAuthVC: UIViewController {

    // MARK: - Properties
    lazy var confettiView: AnimationView = {
        let animationView = AnimationView(name: Const.Lottie.Name.confetti)
        animationView.frame = animationFrameView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    
    // MARK: - IBoutlet properties
    
    @IBOutlet weak var handImageVIew: UIImageView!
    @IBOutlet weak var animationFrameView: UIView!
    @IBOutlet weak var goToFeedButton: UIButton!
    @IBOutlet weak var instaView: UIView!
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setGesture()
        setAnimation()
    }

    // MARK: IBActions
    @IBAction func touchNoDismiss(_ sender: Any) {
        self.dismiss(animated: true) {
//            let presentingVC = self.presentingViewController
//            presentingVC?.navigationController?.popToRootViewController(animated: false)
        }
    }
}

extension CompleteAuthVC {
    
    // MARK: - Methods
    
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        instaView.layer.cornerRadius = 2
    }
    
    private func setGesture() {
        let instaTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        instaView.addGestureRecognizer(instaTapGesture)
    }
    
    private func setAnimation() {
        animationFrameView.addSubview(confettiView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [self] in
            confettiView.play()
        }
    }
    
    // MARK: - @objc
    @objc
    func tapped(_ gesture: UITapGestureRecognizer) {
        // 인스타 공유 기능
    }
}
