//
//  SparkTabBarDelegate.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/13.
//

import Foundation

protocol SparkTabBarDelegate: AnyObject {
    func sparkTabBar(_ sender: SparkTabBar, didSelectItemAt index: Int)
}
