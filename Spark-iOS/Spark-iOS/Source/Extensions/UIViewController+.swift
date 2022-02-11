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
    
    func showSparkToast(x: CGFloat, y: CGFloat, message: String) {
        let backgroundView = UIView(frame: CGRect(x: x,
                                                  y: y,
                                                  width: self.view.frame.size.width - 40,
                                                 height: 100))
        let toastLabel = UILabel()
        let toastImageView = UIImageView()
        
        backgroundView.addSubviews([toastImageView, toastLabel])
        
        toastImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(7)
            make.width.height.equalTo(56)
        }
        
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(toastImageView.snp.bottom)
            make.leading.equalToSuperview().inset(16)
        }
        
        backgroundView.backgroundColor = .sparkWhite
        backgroundView.layer.cornerRadius = 2
        backgroundView.clipsToBounds = true
        backgroundView.layer.shadowColor = UIColor.sparkBlack.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        backgroundView.layer.shadowRadius = 10
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.shadowOpacity = 0.15
        
        toastLabel.text = message
        toastLabel.textColor = .sparkBlack
        toastLabel.textAlignment = .center
        toastLabel.font = .p2Subtitle
        toastImageView.image = UIImage(named: "illustHandSendSpark")
        
        self.view.addSubview(backgroundView)
        backgroundView.alpha = 0.0
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: .curveEaseInOut) {
            backgroundView.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 1.0,
                           options:
                                .curveEaseInOut) {
                backgroundView.alpha = 0.0
            } completion: { _ in
                backgroundView.removeFromSuperview()
            }
        }
    }
    
    /// textField의 글자수에 따라 countLabel과 lineView의 컬러 및 글자 변경해주는 함수
    /// - 최대 글자수 초과인 경우
    /// - 최대 글자수 이하 0 이상인 경우
    /// - 그 외의 경우 (글자수 0)
    func changeCountLabel(textField: UITextField, maxLength: Int, countLabel: UILabel, lineView: UIView) {
        if let text = textField.text {
            countLabel.text = "\(text.count)/\(maxLength)"
            
            if text.count >= maxLength {
                let maxIndex = text.index(text.startIndex, offsetBy: maxLength)
                let newString = String(text[text.startIndex..<maxIndex])
                textField.text = newString
                countLabel.text = "\(maxLength)/\(maxLength)"
                countLabel.textColor = .sparkPinkred
            } else if text.count > 0 {
                let attributedString = NSMutableAttributedString(string: countLabel.text ?? "")
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.sparkPinkred, range: ((countLabel.text ?? "") as NSString).range(of: "\(text.count)"))
                countLabel.textColor = .sparkDarkGray
                countLabel.attributedText = attributedString
            } else {
                countLabel.textColor = .sparkDarkGray
            }
        }
    }
}
