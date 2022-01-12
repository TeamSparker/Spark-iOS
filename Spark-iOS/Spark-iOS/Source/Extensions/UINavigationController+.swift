//
//  UINavigationController+.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/13.
//

import Foundation

import UIKit

extension UINavigationController {
    
    // MARK: - 투명
    
    func initTransparentNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - 뒤로가기 버튼
    
    func initWithBackButton() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.initBackButtonAppearance()
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.tintColor = .black
    }
    
    // MARK: - 뒤로가기 버튼 + 완료 버튼
    
    func initWithBackAndDoneButton(navigationItem: UINavigationItem?, doneButtonClosure: Selector) {
        initWithBackButton()
        
        // done Button
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self.topViewController, action: doneButtonClosure)
        navigationItem?.rightBarButtonItem = doneButton
    }
    
    // MARK: - 커스텀 버튼 1개
    
    func initWithOneCustomButtons(navigationItem: UINavigationItem?, firstButtonImage: UIImage, firstButtonClosure: Selector) {
        initWithBackButton()
        
        let firstButton = UIBarButtonItem(image: firstButtonImage, style: .plain, target: self.topViewController, action: firstButtonClosure)
        navigationItem?.rightBarButtonItem = firstButton
        
    }
    
    // MARK: - 커스텀 버튼 2개
    
    func initWithTwoCustomButtons(navigationItem: UINavigationItem?, firstButtonImage: UIImage, secondButtonImage: UIImage, firstButtonClosure: Selector, secondButtonClosure: Selector) {
        initWithBackButton()
        
        let firstButton = UIBarButtonItem(image: firstButtonImage, style: .plain, target: self.topViewController, action: firstButtonClosure)
        let secondButton = UIBarButtonItem(image: secondButtonImage, style: .plain, target: self.topViewController, action: secondButtonClosure)
        navigationItem?.rightBarButtonItems = [firstButton, secondButton]
        
    }
    
    // MARK: - @objc function
    
    @objc func touchBackButton() {
        popViewController(animated: true)
    }
}

extension UINavigationBarAppearance {
    
    func initBackButtonAppearance() {
        // back button image
        var backButtonImage: UIImage? {
            return UIImage(systemName: "chevron.left")?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -12.0, bottom: -5.0, right: 0.0))
        }
        // back button appearance
        var backButtonAppearance: UIBarButtonItemAppearance {
            let backButtonAppearance = UIBarButtonItemAppearance()
            // backButton하단에 표출되는 text를 안보이게 설정
            backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear, .font: UIFont.systemFont(ofSize: 0.0)]

            return backButtonAppearance
        }
        self.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        self.backButtonAppearance = backButtonAppearance
    }
}
