//
//  Notification.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import Foundation
import UIKit

// notification name 을 확장시켜서 상수로 관리합니다.
extension Notification.Name {
    static let appearFloatingButton = Notification.Name("appearFloatingButton")
    static let disappearFloatingButton = Notification.Name("disappearFloatingButton")
    static let resetStopWatch = Notification.Name("resetStopWatch")
    static let updateHabitRoom = Notification.Name("updateHabitRoom")
    static let leaveRoom = Notification.Name("leaveRoom")
    static let feedReport = Notification.Name("feedReport")
    static let updateHome = Notification.Name("updateHome")
    static let startHabitRoom = Notification.Name("startHabitRoom")
}
