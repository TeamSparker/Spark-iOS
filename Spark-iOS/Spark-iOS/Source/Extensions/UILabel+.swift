//
//  UILabel+.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//
import UIKit

extension UILabel {
    /// 라벨 일부 font 변경해주는 함수
    func partFontChange(targetString: String, font: UIFont) {
        let font = font
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
    
    /// 라벨 일부 textColor 변경해주는 함수
    func partColorChange(targetString: String, textColor: UIColor) {
        let textColor = textColor
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        self.attributedText = attributedString
    }
}
