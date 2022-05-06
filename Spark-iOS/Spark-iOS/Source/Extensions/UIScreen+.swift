//
//  UIScreen+.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/20.
//

import UIKit

extension UIScreen {
    public var hasNotch: Bool {
        let deviceRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        if deviceRatio > 0.5 {
            return false
        } else {
            return true
        }
    }
}
