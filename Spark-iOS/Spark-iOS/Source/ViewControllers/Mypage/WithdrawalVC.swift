//
//  WithdrawalVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/25.
//

import UIKit

class WithdrawalVC: UIViewController {

    // MARK: - Properties
    
    private let customNavigationBar = LeftButtonNavigaitonBar()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
}

// MARK: - Extension

extension WithdrawalVC {
    private func setUI() {
        customNavigationBar.title("회원 탈퇴")
            .leftButtonImage("icBackWhite")
            .leftButtonAction(<#T##clousure: (() -> Void)?##(() -> Void)?##() -> Void#>)
    }
}

// MARK: - Layout

extension WithdrawalVC {
    private func setLayout() {
        
    }
}
