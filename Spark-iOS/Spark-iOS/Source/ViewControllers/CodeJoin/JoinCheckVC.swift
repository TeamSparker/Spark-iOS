//
//  JoinCheckVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/14.
//

import UIKit

class JoinCheckVC: UIViewController {

    @IBOutlet weak var reInputButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var userInviteLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        reInputButton.setTitleColor(.sparkLightPinkred, for: .highlighted)
        reInputButton.layer.borderColor = .init(_colorLiteralRed: 1, green: 0, blue: 66/255, alpha: 1)
        reInputButton.layer.borderWidth = 1
        
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.setTitleColor(.white, for: .selected)
        enterButton.setTitleColor(.sparkGray, for: .highlighted)
        enterButton.backgroundColor = .sparkDarkPinkred
        enterButton.titleLabel?.font = .btn1Default
        enterButton.layer.borderWidth = 0
    }
    
    @IBAction func touchReinputCode(_ sender: Any) {
        
    }
    
    @IBAction func touchEnterWaitingVC(_ sender: Any) {
        let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.waiting, bundle:nil)
        
        guard let nextVC = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.waiting) as? WaitingVC else {return}
        
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
}
