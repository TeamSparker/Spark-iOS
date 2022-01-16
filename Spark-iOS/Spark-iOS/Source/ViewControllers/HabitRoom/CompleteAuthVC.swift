//
//  CompleteAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit

class CompleteAuthVC: UIViewController {

    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var instaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setGesture()
    }

    @IBAction func touchNoDismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

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
}
