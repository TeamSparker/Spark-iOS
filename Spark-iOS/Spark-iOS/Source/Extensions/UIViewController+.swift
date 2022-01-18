//
//  UIViewController+.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/14.
//

import UIKit

extension UIViewController {
    func showToast(x: CGFloat, y: CGFloat, message: String, font: UIFont) {
        var toastLabel = UILabel()
        toastLabel = UILabel(frame: CGRect(x: x,
                                           y: y,
                                           width: self.view.frame.size.width - 40,
                                           height: 40))
        
        toastLabel.backgroundColor = .sparkDeepGray
        toastLabel.textColor = .sparkWhite
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.alpha = 0.9
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 2
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.6,
                       options: .curveEaseIn, animations: { toastLabel.alpha = 0.0 },
                       completion: {_ in toastLabel.removeFromSuperview() })
    }
}
