//
//  CompleteAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit

import FirebaseAnalytics
import Lottie

class CompleteAuthVC: UIViewController {
    
    // MARK: - Properties
    var vcType: VCCase?
    
    var renderedImage: UIImage?
    var roomName: String?
    var nickName: String?
    var profileImage: String?
    var timerCount: String?
    var leftDay: Int?
    let viewForRender = ViewForRender()
    
    private lazy var confettiView: AnimationView = {
        let animationView = AnimationView(name: Const.Lottie.Name.confetti)
        animationView.frame = animationFrameView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    
    // MARK: - IBoutlet properties
    
    @IBOutlet weak var popUpMainView: UIView!
    @IBOutlet weak var animationFrameView: UIView!
    @IBOutlet weak var goToFeedButton: UIButton!
    @IBOutlet weak var instaView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var encourageLabel: UILabel!
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setGesture()
        setAnimation()
    }
    
    // MARK: IBActions
    @IBAction func goToFeedVC(_ sender: Any) {
        guard let presentingVC = self.presentingViewController?.presentingViewController as? UITabBarController else { return }
        guard let naviVC = presentingVC.viewControllers?[1] as? UINavigationController else { return }
        
        goToFeedTracking()
        
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
        
        popUpMainView.layer.cornerRadius = 2
        
        instaView.layer.cornerRadius = 2
        
        dayLabel.text = "Day \(66-(leftDay ?? 65))"
        
        let sparkFlake = SparkFlake(leftDay: leftDay ?? 65)
        encourageLabel.text = sparkFlake.completeAuthText()
        
        viewForRender.roomNameLabel.text = roomName
        viewForRender.nickNameLabel.text = nickName
        viewForRender.timerLabel.text = timerCount
        viewForRender.authImageView.image = renderedImage
        viewForRender.profileImageView.updateImage(profileImage ?? "", type: .small)
    }
    
    private func setLayout() {
        self.view.addSubview(viewForRender)
        
        viewForRender.snp.makeConstraints { make in
            make.width.equalTo(328)
            make.height.equalTo(478)
            make.trailing.equalToSuperview().inset(-1000)
        }
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
                    "com.instagram.sharedSticker.backgroundTopColor": "#8D8D88",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#8D8D88"]

                let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)]

                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
            } else {
                print("인스타 앱이 깔려있지 않습니다.")
            }
        }
    }
    
    private func goToFeedTracking() {
        Analytics.logEvent(Tracking.Select.clickFeed, parameters: nil)
    }
    
    private func shareTracking() {
        Analytics.logEvent(Tracking.Select.clickShare, parameters: nil)
    }
    
    // MARK: - @objc
    @objc
    func tapped(_ gesture: UITapGestureRecognizer) {
        
        shareTracking()
        shareAuthWithInstagram()
    }
}
