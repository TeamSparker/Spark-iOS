//
//  UIFont+Extension.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import Foundation
import UIKit

struct AppFontName {
    static let enBold = "Futura-Bold"
    static let enMedium = "Futura-Medium"
    static let enMediumItalic = "Futura-MediumItalic"
    static let krBold = "NotoSansKR-Bold"
    static let krMeduim = "NotoSansKR-Medium"
    static let krRegular = "NotoSansKR-Regular"
}

extension UIFont {
    /// font에 따라 사용하며, 폰트 크기 지정O
    /// ex) textLabel.font = .enBoldFont(ofSize: 30)
    @nonobjc class func enBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.enBold, size: size)!
    }
    
    @nonobjc class func enMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.enMedium, size: size)!
    }
    
    @nonobjc class func enMediumItatlicFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.enMediumItalic, size: size)!
    }
    
    @nonobjc class func krBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.krBold, size: size)!
    }
    
    @nonobjc class func krMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.krMeduim, size: size)!
    }
    
    @nonobjc class func krRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.krRegular, size: size)!
    }
    
    /// typo에 따라 사용하며, 폰트 크기 지정X
    /// ex) textLabel.font = .h1BigtitleEng
    @nonobjc class var h1BigtitleEng: UIFont {
        return UIFont(name: AppFontName.enBold, size: 31.0)!
    }
    
    @nonobjc class var h1Bigtitle: UIFont {
        return UIFont(name: AppFontName.krBold, size: 24.0)!
    }
    
    @nonobjc class var h2TitleEng: UIFont {
        return UIFont(name: AppFontName.enBold, size: 20.0)!
    }
    
    @nonobjc class var h2Title: UIFont {
        return UIFont(name: AppFontName.krMeduim, size: 20.0)!
    }
    
    @nonobjc class var btn1Default: UIFont {
        return UIFont(name: AppFontName.krBold, size: 18.0)!
    }
    
    @nonobjc class var h3SubtitleEng: UIFont {
        return UIFont(name: AppFontName.enMedium, size: 18.0)!
    }
    
    @nonobjc class var h3SubtitleEngItalic: UIFont {
        return UIFont(name: AppFontName.enMediumItalic, size: 18.0)!
    }
    
    @nonobjc class var h3Subtitle: UIFont {
        return UIFont(name: AppFontName.krMeduim, size: 18.0)!
    }
    
    @nonobjc class var btn2: UIFont {
        return UIFont(name: AppFontName.krMeduim, size: 16.0)!
    }
    
    @nonobjc class var p1Title: UIFont {
        return UIFont(name: AppFontName.krMeduim, size: 16.0)!
    }
    
    @nonobjc class var btn3: UIFont {
        return UIFont(name: AppFontName.krRegular, size: 16.0)!
    }
    
    @nonobjc class var p1TitleLight: UIFont {
        return UIFont(name: AppFontName.krRegular, size: 16.0)!
    }
    
    @nonobjc class var p2Subtitle2Eng: UIFont {
        return UIFont(name: AppFontName.enBold, size: 14.0)!
    }
    
    @nonobjc class var p2SubtitleEng: UIFont {
        return UIFont(name: AppFontName.enMedium, size: 14.0)!
    }
    
    @nonobjc class var p2Subtitle: UIFont {
        return UIFont(name: AppFontName.krRegular, size: 14.0)!
    }
    
    @nonobjc class var captionEng: UIFont {
        return UIFont(name: AppFontName.enMedium, size: 12.0)!
    }
    
    @nonobjc class var caption: UIFont {
        return UIFont(name: AppFontName.krRegular, size: 12.0)!
    }
}
