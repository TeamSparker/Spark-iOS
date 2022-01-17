//
//  SendSparkVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/18.
//

import UIKit

class SendSparkVC: UIViewController {

    // MARK: IBoutlet properties
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
}

// MARK: Methods

extension SendSparkVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        [firstButton, secondButton, thirdButton, fourthButton].forEach {
            $0?.tintColor = .sparkLightPinkred
            $0?.layer.borderColor = UIColor.sparkLightPinkred.cgColor
            $0?.layer.cornerRadius = 2
            $0?.layer.borderWidth = 1
            $0?.setTitleColor(.sparkLightPinkred, for: .normal)
        }
    }
}
