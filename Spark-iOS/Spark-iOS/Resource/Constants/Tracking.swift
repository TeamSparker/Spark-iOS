//
//  Tracking.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/04/25.
//

import Foundation

struct Tracking {
    struct View {
        static let viewHome = "view_home"
        static let viewStopwatch = "view_stopwatch"
        static let viewWaitingRoom = "view_waiting_room"
        static let viewSocialSignup = "view_social_signup"
        static let viewHabitRoom = "view_habit_room"
    }
    
    struct Select {
        static let clickHeartFeed = "click_HEART_feed"
        static let clickNextCreateRoom = "click_NEXT_create_room"
        static let clickUpload = "click_UPLOAD"
        static let clickStartHabit = "click_START_HABIT"
        static let clickSparkUonly = "click_MASSAGE_UONLY_spark"
        static let clickSparkFighting = "click_MASSAGE_FIGHTING_spark"
        static let clickSparkTogether = "click_MASSAGE_TOGETHER_spark"
        static let clickSparkHurry = "click_MASSAGE_HURRY_spark"
        static let clickSparkInputText = "click_INPUT_TEXT_spark"
        static let clickSignup = "click_FINISH_SIGNUP"
        static let clickConsider = "click_CONSIDER_habit_room"
        static let clickCertifying = "click_CERTIFYING_NOW"
        static let clickOK = "click_OK_input_code"
        static let clickFeed = "click_FEED"
        static let clickShare = "click_SHARE_INSTAGRAM"
        static let clickCard = "click_CARD_my_room"
        static let clickTimelineWithNew = "click_TIMELINE_NEW_habit_room"
        static let clickTimeline = "click_TIMELINE_NONE_habit_room"
    }
    
    struct Notification {
        static let spark = "notification_open_SPARK"
        static let certification = "notification_open_CERTIFICATION"
        static let remind = "notification_open_REMIND"
        static let roomstart = "notification_open_ROOMSTART"
        static let consider = "notification_open_CONSIDER"
    }
}
