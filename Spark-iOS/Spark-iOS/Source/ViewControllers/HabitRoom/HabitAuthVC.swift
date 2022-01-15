//
//  HabitAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit

class HabitAuthVC: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var considerButton: UIButton!
    @IBOutlet weak var restButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAddTargets()
    }
}

extension HabitAuthVC {
    func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        popUpView.layer.cornerRadius = 2
        
        okButton.isEnabled = true
        okButton.layer.cornerRadius = 2
        okButton.titleLabel?.text = "지금 습관 인증하기"
        okButton.backgroundColor = .sparkDarkPinkred
        okButton.tintColor = .sparkGray
        okButton.setTitleColor(.sparkGray, for: .highlighted)
        
        considerButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        considerButton.layer.borderColor = .init(_colorLiteralRed: 1, green: 137/255, blue: 165/255, alpha: 1)
        considerButton.layer.borderWidth = 1
        considerButton.layer.cornerRadius = 2
        
        restButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        restButton.layer.borderColor = .init(_colorLiteralRed: 1, green: 137/255, blue: 165/255, alpha: 1)
        restButton.layer.borderWidth = 1
        restButton.layer.cornerRadius = 2
    }
    
    func setAddTargets() {
        okButton.addTarget(self, action: #selector(touchOkayButton), for:. touchUpInside)
    }
    
    @objc func touchOkayButton() {
        let alter = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alter.view.tintColor = .sparkBlack
        
        /// alter에 들어갈 액션 생성
        let library = UIAlertAction(title: "카메라 촬영", style: .default) { action in
//            self.openLibrary()
        }
        let camera = UIAlertAction(title: "앨범에서 선택하기", style: .default) { action in
//            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        /// alter에 액션을 넣어줌
        alter.addAction(library)
        alter.addAction(camera)
        alter.addAction(cancel)
        
        /// button tap했을 때 alter present
        present(alter, animated: true, completion: nil)
        
//        let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.photoAuth, bundle:nil)
//
//        guard let nextVC = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.photoAuth) as? PhotoAuthVC else {return}
//
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: false, completion: nil)
    }
}
