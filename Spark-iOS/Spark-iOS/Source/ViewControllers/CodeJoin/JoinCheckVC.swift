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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        reInputButton.setTitleColor(.sparkDarkPinkred, for: .normal)
        reInputButton.layer.borderColor = .init(_colorLiteralRed: 255, green: 0, blue: 11, alpha: 1)
        reInputButton.layer.borderWidth = 1
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.backgroundColor = .sparkDarkPinkred
        enterButton.titleLabel?.font = .btn1Default
        enterButton.titleLabel?.textColor = .sparkWhite
        enterButton.layer.borderWidth = 0
    }
}
