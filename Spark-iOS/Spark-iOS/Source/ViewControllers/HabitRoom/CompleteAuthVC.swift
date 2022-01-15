//
//  CompleteAuthVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit

class CompleteAuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

}

extension CompleteAuthVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
    }
}
