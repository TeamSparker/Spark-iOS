//
//  OnboardingCVCViewModel.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/03/12.
//

import UIKit

struct OnboardingCVCViewModel {
    
    // MARK: Properties
    
    private let index: Int
    
    private let guideArray: [String] = [ """
                                 습관 만들기,
                                 친구와 함께 도전해보는 건
                                 어때요?
                                 """,
                                 """
                                 함께 습관방의 생명을 지키면서
                                 더 재미있게!
                                 """,
                                 """
                                 66일의 시간,
                                 목표를 갖고 달리면 덜 힘들걸요?
                                 """,
                                 """
                                 지금, 응원의 스파크를 주고받으며
                                 습관을 만들어봐요!
                                 """ ]
    
    var mainImage: UIImage? {
        return UIImage()
    }
    
    var guideText: NSAttributedString {
        switch index {
        case 0:
            return attributedTitle(startIndex: 8, length: 6)
        case 1:
            return attributedTitle(startIndex: 17, length: 7)
        case 2:
            return attributedTitle(startIndex: 0, length: 8)
        default:
            return attributedTitle(startIndex: 8, length: 3)
        }
    }
    
    // MARK: Initializer
    
    init(index: Int) {
        self.index = index
    }
    
    // MARK: Methods
    
    private func attributedTitle(startIndex: Int, length: Int) -> NSAttributedString {
        let pinkAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.sparkPinkred]
        let text = guideArray[index]
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(pinkAtts, range: NSRange(location: startIndex, length: length))
        return attributedString
    }
}
