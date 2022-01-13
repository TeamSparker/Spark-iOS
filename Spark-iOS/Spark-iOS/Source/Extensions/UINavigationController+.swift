//
//  UINavigationController+.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/13.
//

import Foundation

import UIKit

extension UINavigationController {
    
    /// 투명
    func initTransparentNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
    
    /// 뒤로가기 버튼
    func initWithBackButton(tintColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.initBackButtonAppearance()
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationBar.tintColor = tintColor
    }
    
    /// 뒤로가기 버튼 + 제목.
    /// - title 에는 네비게이션바 타이틀을 넣어주세요.
    func initWithTitle(title: String) {
        initWithBackButton(tintColor: .sparkWhite)
        
        self.navigationController?.title = title
    }
    
    /// 홈 우측 버튼 두개.
    /// - navigationItem 에는 해당 뷰컨트롤러의 네비게이션바를 넣어주세요
    /// - clouser 에는 해당 버튼이 눌렸을 때 화면전환을 넣어주세요
    func initWithTwoCustomButtons(navigationItem: UINavigationItem?, firstButtonClosure: Selector, secondButtonClosure: Selector) {
        initWithBackButton(tintColor: .sparkBlack)
        
        let firstButton = UIBarButtonItem(image: UIImage(named: "icProfile"), style: .plain, target: self.topViewController, action: firstButtonClosure)
        let secondButton = UIBarButtonItem(image: UIImage(named: "icNotice"), style: .plain, target: self.topViewController, action: secondButtonClosure)
        navigationItem?.rightBarButtonItems = [firstButton, secondButton]
    }
}

extension UINavigationBarAppearance {
    func initBackButtonAppearance() {
        var backButtonImage: UIImage? {
//            return UIImage(named: "icBackWhite")?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -12.0, bottom: -5.0, right: 0.0))
            return UIImage(named: "icBackWhite")
        }

        var backButtonAppearance: UIBarButtonItemAppearance {
            let backButtonAppearance = UIBarButtonItemAppearance()
            // backButton 옆에 표출되는 text를 안보이게 설정
            backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear, .font: UIFont.systemFont(ofSize: 0.0)]

            return backButtonAppearance
        }
        self.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        self.backButtonAppearance = backButtonAppearance
    }
}
