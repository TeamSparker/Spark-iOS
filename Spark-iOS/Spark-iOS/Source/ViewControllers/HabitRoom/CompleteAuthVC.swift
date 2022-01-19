//
//  CompleteAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit
import Lottie

class CompleteAuthVC: UIViewController {

    // MARK: Properties
    lazy var confettiView: AnimationView = {
        let animationView = AnimationView(name: Const.Lottie.Name.confetti)
        animationView.frame = animationFrameView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    
    // MARK: IBoutlet properties
    
    @IBOutlet weak var handImageVIew: UIImageView!
    @IBOutlet weak var animationFrameView: UIView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var instaView: UIView!
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setGesture()
        setAnimation()

        getMyRoomWithAPI()
        getMyRoomCertiWithAPI()
    }

    // MARK: IBActions
    @IBAction func touchNoDismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: Methods
extension CompleteAuthVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        instaView.layer.cornerRadius = 2
    }
    
    private func setGesture() {
        let instaTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        instaView.addGestureRecognizer(instaTapGesture)
    }
    
    @objc
    func tapped(_ gesture: UITapGestureRecognizer) {
        // 인스타 공유 기능
    }
    
    private func setAnimation() {
        animationFrameView.addSubview(confettiView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [self] in
            confettiView.play()
        }
    }
}

extension CompleteAuthVC {
    
    func getMyRoomWithAPI() {
        MyRoomAPI.shared.myRoomFetch(roomType: "ONGOING", lastID: -1, size: 100) {  response in
            switch response {
            case .success(let data):
                if let myRoom = data as? MyRoom {
                    print(myRoom)
                }
            case .requestErr(let message):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func getMyRoomCertiWithAPI() {
        MyRoomAPI.shared.myRoomCertiFetch(roomID: 2, lastID: -1, size: 7) {  response in
            switch response {
            case .success(let data):
                if let myRoomCerti = data as? MyRoomCertification {
                    print(myRoomCerti)
                }
            case .requestErr(let message):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
}
