//
//  MainVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
}

// MARK: - Methods

extension HomeVC {
    private func setUI() {
        navigationController?.initWithTwoCustomButtons(navigationItem: self.navigationItem, firstButtonClosure: #selector(presentToProfileVC), secondButtonClosure: #selector(presentToAertVC))
    }
    
    // MARK: - @objc
    
    @objc
    private func presentToProfileVC() {
        
    }
    
    @objc
    private func presentToAertVC() {
        
    }
}
