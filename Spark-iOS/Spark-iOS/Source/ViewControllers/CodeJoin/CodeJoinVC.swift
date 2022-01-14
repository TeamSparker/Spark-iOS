//
//  CodeJoinVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/14.
//

import UIKit

class CodeJoinVC: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAddTargets()
    }
    
    func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        popUpView.layer.cornerRadius = 2
        
        errorLabel.textColor = .sparkBrightPinkred
        errorLabel.font = .p2Subtitle
    }
    
    func setAddTargets() {
        okButton.addTarget(self, action: #selector(touchOkayButton), for:. touchUpInside)
    }

    @objc func touchOkayButton() {
        let nextSB = UIStoryboard.init(name: "JoinCheck", bundle:nil)
        
        guard let nextVC = nextSB.instantiateViewController(identifier: "JoinCheckVC") as? JoinCheckVC else {return}
        
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    
    @IBAction func touchOutsideButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
