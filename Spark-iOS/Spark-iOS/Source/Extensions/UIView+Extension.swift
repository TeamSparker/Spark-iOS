//
//  UIView+Extension.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/12.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
