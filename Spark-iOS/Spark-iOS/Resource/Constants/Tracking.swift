//
//  Tracking.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/04/25.
//

import Foundation

struct Tracking {
    static let viewHome = "view_home"
    static let viewStopwatch = "view_stopwatch"
    static let viewWaitingRoom = "view_waiting_room"
    static let clickHeartFeed = "click_HEART_feed"
    static let clickNextCreateRoom = "click_NEXT_create_room"
    static let clickUpload = "click_UPLOAD"
    static let clickStartHabit = "click_START_HABIT"
}

extension Tracking {
    struct ScreenName {
        static let home = "homeName"
        static let stopwatch = "stopwatchName"
        static let waitingRoom = "waitingRoomName"
    }
    
    struct ScreenClass {
        static let home = "homeClass"
        static let stopwatch = "stopwatchClass"
        static let waitingRoom = "waitingRoomClass"
    }
}
