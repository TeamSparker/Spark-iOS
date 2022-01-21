//
//  CompleteAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit

import Lottie
import SwiftUI

class CompleteAuthVC: UIViewController {
    
    // MARK: - Properties
    lazy var confettiView: AnimationView = {
        let animationView = AnimationView(name: Const.Lottie.Name.confetti)
        animationView.frame = animationFrameView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    
    var vcType: VCCase?
    
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
    @IBAction func goToFeedVC(_ sender: Any) {
        guard let presentingVC = self.presentingViewController?.presentingViewController as? UINavigationController else { return }
        
        switch vcType {
        case .photoOnly:
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                presentingVC.popToRootViewController(animated: false)
                guard let mainTBC = presentingVC.viewControllers.first as? UITabBarController else { return }
                mainTBC.selectedIndex = 0
                
            })
        case .photoTimer:
            self.presentingViewController?.presentingViewController?.dismiss(animated: true) {
                // FIXME: - 피드로 가야된다
                presentingVC.popToRootViewController(animated: true)
            }
        default:
            break
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
