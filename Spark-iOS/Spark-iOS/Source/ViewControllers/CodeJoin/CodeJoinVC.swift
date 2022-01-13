//
//  CodeJoinVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/14.
//

import UIKit

class CodeJoinVC: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        popUpView.layer.cornerRadius = 2
    }
}
