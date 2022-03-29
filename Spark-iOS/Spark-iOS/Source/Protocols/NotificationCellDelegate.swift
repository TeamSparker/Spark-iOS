//
//  NotificationCellDelegate.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/28.
//

import Foundation

protocol notificationCellDelegate: AnyObject {
    func notificationSwitchToggle(category: String)
}
