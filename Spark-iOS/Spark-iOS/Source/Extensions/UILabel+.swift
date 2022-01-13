//
//  UILabel+.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//
import UIKit

extension UILabel {
    // string 일부 폰트를 .p1Title로 바꿔주는 함수
    func medium(targetString: String) {
        let font = UIFont.p1Title
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
    
//    func colorChange(targetString: String) {
//        let textcolor = UIColor.sparkGray
//        let fullText = self.text ?? ""
//        let range = (fullText as NSString).range(of: targetString)
//        let attributedString = nsforegroun(string: fullText)
//        attributedString.addAttribute(.textColor, range: )
//    }
    
//    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
//
//        let attributes:[NSAttributedString.Key : Any] = [
////            .font: normalFont,
//            .foregroundColor: UIColor.white,
//            .backgroundColor: UIColor.orange
//        ]
//
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
}
