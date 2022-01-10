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

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    /// font에 따라 사용하며, 폰트 크기 지정O
    /// ex) textLabel.font = .enBoldFont(ofSize: 30)
    @objc class func enBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.enBold, size: size)!
    }
    
    @objc class func enMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.enMedium, size: size)!
    }
    
    @objc class func enMediumItatlicFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.enMediumItalic, size: size)!
    }
    
    @objc class func krBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.krBold, size: size)!
    }
    
    @objc class func krMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.krMeduim, size: size)!
    }
    
    @objc class func krRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.krRegular, size: size)!
    }
    
    /// typo에 따라 사용하며, 폰트 크기 지정X
    /// ex) textLabel.font = .h1BigtitleEng
    class var h1BigtitleEng: UIFont {
        return UIFont(name: "Futura-Bold", size: 31.0)!
    }
    
    class var h1Bigtitle: UIFont {
        return UIFont(name: "NotoSansKR-Bold", size: 24.0)!
    }
    
    class var h2TitleEng: UIFont {
        return UIFont(name: "Futura-Bold", size: 20.0)!
    }
    
    class var h2Title: UIFont {
        return UIFont(name: "NotoSansKR-Medium", size: 20.0)!
    }
    
    class var btn1Default: UIFont {
        return UIFont(name: "NotoSansKR-Bold", size: 18.0)!
    }
    
    class var h3SubtitleEng: UIFont {
        return UIFont(name: "Futura-Medium", size: 18.0)!
    }
    
    class var h3SubtitleEngItalic: UIFont {
        return UIFont(name: "Futura-MediumItalic", size: 18.0)!
    }
    
    class var h3Subtitle: UIFont {
        return UIFont(name: "NotoSansKR-Medium", size: 18.0)!
    }
    
    class var btn2: UIFont {
        return UIFont(name: "NotoSansKR-Medium", size: 16.0)!
    }
    
    class var p1Title: UIFont {
        return UIFont(name: "NotoSansKR-Medium", size: 16.0)!
    }
    
    class var btn3: UIFont {
        return UIFont(name: "NotoSansKR-Regular", size: 16.0)!
    }
    
    class var p1TitleLight: UIFont {
        return UIFont(name: "NotoSansKR-Regular", size: 16.0)!
    }
    
    class var p2Subtitle2Eng: UIFont {
        return UIFont(name: "Futura-Bold", size: 14.0)!
    }
    
    class var p2SubtitleEng: UIFont {
        return UIFont(name: "Futura-Medium", size: 14.0)!
    }
    
    class var p2Subtitle: UIFont {
        return UIFont(name: "NotoSansKR-Regular", size: 14.0)!
    }
    
    class var captionEng: UIFont {
        return UIFont(name: "Futura-Medium", size: 12.0)!
    }
    
    class var caption: UIFont {
        return UIFont(name: "NotoSansKR-Regular", size: 12.0)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.krRegular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.krMeduim
                case "CTFontObliqueUsage":
                    fontName = AppFontName.krBold
                default:
                    fontName = AppFontName.krRegular
                }
                self.init(name: fontName, size: fontDescriptor.pointSize)!
            }
            else {
                self.init(myCoder: aDecoder)
            }
        }
        else {
            self.init(myCoder: aDecoder)
        }
    }
    
    class func overrideInitialize() {
        if self == UIFont.self {
            let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
            let mySystemFontMethod = class_getClassMethod(self, #selector(krRegularFont(ofSize:)))
            method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)
            
            let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(krBoldFont(ofSize:)))
            method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)
            
            let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(enMediumItatlicFont(ofSize:)))
            method_exchangeImplementations(italicSystemFontMethod!, myItalicSystemFontMethod!)
            
            let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))) // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
            method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
        }
    }
}
