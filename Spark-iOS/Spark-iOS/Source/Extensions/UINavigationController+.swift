//
//  UINavigationController+.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/13.
//

import Foundation

import UIKit

extension UINavigationController {
    
    private func initNavigationBarAppearance(backgroundColor: UIColor) -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = backgroundColor
        
        return appearance
    }
    
    private func initWithBackButton(tintColor: UIColor, backgroundColor: UIColor) {
        let appearance: UINavigationBarAppearance = initNavigationBarAppearance(backgroundColor: backgroundColor)
        appearance.initBackButtonAppearance()
        appearance.initTitleTextAttributes(tintColor: tintColor)
        
        self.navigationBar.tintColor = tintColor
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
    
    /// 뒤로가기 버튼 + 제목.
    /// - title 에는 네비게이션바 타이틀을 넣어주세요.
    /// - tintColor 에는 틴트컬러를 넣어주세요.
    /// - backgounrdColor 에는 배경색을 넣어주세요.
    public func initWithBackButtonTitle(title: String, tintColor: UIColor, backgroundColor: UIColor) {
        initWithBackButton(tintColor: tintColor, backgroundColor: backgroundColor)
        
        self.navigationBar.topItem?.title = title
    }

    /// 좌측 버튼 + 텍스트
    /// - title 에는 타이틀 텍스트를 넣어주세요.
    /// - tintColor 에는 틴트컬러를 넣어주세요.
    /// - backgounrdColor 에는 배경색을 넣어주세요.
    /// - image 에는 좌측 버튼의 이미지를 넣어주세요.
    /// - selector 에는 작동하는 액션을 넣어주세요.
    public func initWithLeftButtonTitle(title: String, tintColor: UIColor, backgroundColor: UIColor, image: UIImage?, selector: Selector) {
        let appearance: UINavigationBarAppearance = initNavigationBarAppearance(backgroundColor: backgroundColor)
        appearance.initTitleTextAttributes(tintColor: tintColor)
        self.navigationBar.topItem?.title = title
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        
        self.navigationBar.tintColor = tintColor
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
    
    /// 홈 우측 버튼 두개.
    /// - navigationItem 에는 해당 뷰컨트롤러의 네비게이션바를 넣어주세요.
    /// - tintColor 에는 틴트컬러를 넣어주세요.
    /// - backgounrdColor 에는 배경색을 넣어주세요.
    /// - closure 에는 해당 버튼이 눌렸을 때 액션을 넣어주세요.
    public func initWithRightTwoCustomButtons(navigationItem: UINavigationItem?, tintColor: UIColor, backgroundColor: UIColor, firstButtonSelector: Selector, secondButtonSelector: Selector) {
        let appearance: UINavigationBarAppearance = initNavigationBarAppearance(backgroundColor: backgroundColor)
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.tintColor = tintColor
        navigationItem?.title = ""
        
        let firstButton = UIBarButtonItem(image: UIImage(named: "icProfile"), style: .plain, target: self.topViewController, action: firstButtonSelector)
        let secondButton = UIBarButtonItem(image: UIImage(named: "icNotice"), style: .plain, target: self.topViewController, action: secondButtonSelector)
        navigationItem?.rightBarButtonItems = [firstButton, secondButton]
    }
    
    /// 커스텀 버튼 두개 + 제목.
    /// - navigationItem 에는 해당 뷰컨트롤러의 네비게이션바를 넣어주세요.
    /// - title 에는 타이틀을 넣어주세요.
    /// - tintColor 에는 틴트컬러를 넣어주세요.
    /// - backgounrdColor 에는 배경색을 넣어주세요.
    /// - reftButtonIcon 에는 좌측 버튼 이미지를. rightButtonIcon 에는 우측 버튼 이미지를 넣어주세요.
    /// - closure 에는 해당 버튼이 눌렸을 때 액션을 넣어주세요.
    public func initWithTwoCustomButtonsTitle(navigationItem: UINavigationItem?, title: String, tintColor: UIColor, backgroundColor: UIColor, reftButtonImage: UIImage?, rightButtonImage: UIImage, reftButtonSelector: Selector, rightButtonSelector: Selector) {
        let appearance: UINavigationBarAppearance = initNavigationBarAppearance(backgroundColor: backgroundColor)
        appearance.initTitleTextAttributes(tintColor: .sparkBlack)
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.tintColor = tintColor
        
        let reftButton = UIBarButtonItem(image: reftButtonImage, style: .plain, target: self.topViewController, action: reftButtonSelector)
        let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self.topViewController, action: rightButtonSelector)
        navigationItem?.leftBarButtonItem = reftButton
        navigationItem?.rightBarButtonItem = rightButton
        
        self.navigationBar.topItem?.title = title
    }
}

extension UINavigationBarAppearance {
    func initBackButtonAppearance() {
        var backButtonImage: UIImage? {
            // back button 위치 조정
            return UIImage(named: "icBackWhite")?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: 0.0))
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
    
    func initTitleTextAttributes(tintColor: UIColor) {
        self.titleTextAttributes = [NSAttributedString.Key.font: UIFont.h3Subtitle, NSAttributedString.Key.foregroundColor: tintColor]
    }
}
