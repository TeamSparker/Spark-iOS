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
        reInputButton.layer.borderColor = .init(_colorLiteralRed: 255, green: 0, blue: 66, alpha: 1)
        // 이거 왜 핑크색이냐
        reInputButton.layer.borderWidth = 1
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.setTitleColor(.white, for: .selected)
        enterButton.setTitleColor(.sparkLightGray, for: .highlighted)
        enterButton.backgroundColor = .sparkDarkPinkred
        enterButton.titleLabel?.font = .btn1Default
//        var titleAttribute: NSAttributedString
//        titleAttribute.value(forKey: .)
//        enterButton.setAttributedTitle(NSAttributedString.Key.font: UIFont.btn1Default, for: .selected)
//        enterButton.setAttributedTitle(title: NSAttributedString.Key.font: UIFont.btn1Default, for: <#T##UIControl.State#>)
        enterButton.layer.borderWidth = 0
    }
}
