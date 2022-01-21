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
    
    var renderedImage: UIImage?
    var roomName: String?
    var nickName: String?
    var profileImage: String?
    
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
        guard let presentingVC = self.presentingViewController?.presentingViewController as? UITabBarController else { return }
        guard let naviVC = presentingVC.viewControllers?[1] as? UINavigationController else { return }
        
        presentingVC.dismiss(animated: false) {
            naviVC.popViewController(animated: false)
            presentingVC.selectedIndex = 0
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
    
    // TODO: 인스타 공유 부분
//    func backgroundImage(backgroundImage: UIImage) {
//        if let storyShareURL = URL(string: "instagram-stories://share") {
//            if UIApplication.shared.canOpenURL(storyShareURL) {
//                guard let imageData = backgroundImage.pngData() else {return}
//
//                let renderer = UIGraphicsImageRenderer(size: handImageVIew.bounds.size)
//
//                let renderImage = renderer.image { _ in
//                    handImageVIew.drawHierarchy(in: handImageVIew.bounds, afterScreenUpdates: true)
//                }
//
//                let pasteboardItems : [String:Any] = [
//                    "com.instagram.sharedSticker.stickerImage": imageData,
//                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
//                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
//                ]
//
//                let pasteboardOptions = [
//                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
//                ]
//
//                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
//
//                UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
//
//            } else {
//                print("인스타 앱이 깔려있지 않습니다.")
//            }
//        }
//    }
    private func shareAuthWithInstagram() {
        let renderer = UIGraphicsImageRenderer(size: viewForRender.bounds.size)
        let renderImage = renderer.image { _ in
            viewForRender.drawHierarchy(in: viewForRender.bounds, afterScreenUpdates: true)
        }
        
        if let storyShareURL = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storyShareURL) {
                guard let imageData = renderImage.pngData() else {return}

                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"]

                let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]

                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
            } else {
                print("인스타 앱이 깔려있지 않습니다.")
            }
        }
    }
    
    // MARK: - @objc
    @objc
    func tapped(_ gesture: UITapGestureRecognizer) {
        shareAuthWithInstagram()
    }
}
