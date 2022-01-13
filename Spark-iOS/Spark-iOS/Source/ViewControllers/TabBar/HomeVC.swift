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
        navigationController?.initWithTwoCustomButtons(navigationItem: self.navigationItem,
                                                       tintColor: .sparkBlack,
                                                       backgroundColor: .sparkWhite,
                                                       firstButtonClosure: #selector(presentToProfileVC),
                                                       secondButtonClosure: #selector(presentToAertVC))
    }
    
    // MARK: - @objc
    
    // TODO: - 화면전환 코드 생성
    
    @objc
    private func presentToProfileVC() {
        
    }
    
    @objc
    private func presentToAertVC() {
        
    }
}
