//
//  SparkFlake.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/17.
//

import Foundation
import UIKit

public class SparkFlake {
    
    private let state: SparkFlakeState
    
    @frozen
    private enum SparkFlakeState {
        case day66
        case day65
        case day62
        case day58
        case day32
        case day6
        case dDay
    }

    public init(leftDay: Int) {
        if 66 == leftDay {
            self.state = .day66
        } else if 65 >= leftDay && leftDay > 62 {
            self.state = .day65
        } else if 62 >= leftDay && leftDay > 58 {
            self.state = .day65
        } else if 58 >= leftDay && leftDay > 32 {
            self.state = .day58
        } else if 32 >= leftDay && leftDay > 6 {
            self.state = .day32
        } else if 6 >= leftDay && leftDay > 0 {
            self.state = .day6
        } else {
            self.state = .dDay
        }
    }
    
    /// 티켓 배경 flake
    public func sparkFlakeTicketImage() -> UIImage? {
        switch state {
        case .day66:
            return UIImage(named: "property1TicketLeftSparkflake14")
        case .day65:
            return UIImage(named: "property1TicketLeftSparkflake14")
        case .day62:
            return UIImage(named: "property1TicketLeftSparkflake24")
        case .day58:
            return UIImage(named: "property1TicketLeftSparkflake34")
        case .day32:
            return UIImage(named: "property1TicketLeftSparkflake44")
        case .day6:
            return UIImage(named: "property1TicketLeftSparkflake54")
        case .dDay:
            return UIImage(named: "property1TicketLeftSparkflake64")
        }
    }
    
    /// 티켓 멘트
    public func sparkFlakeMent() -> String {
        switch state {
        case .day66:
            return "내일부터 시작!"
        case .day65:
            return "작심삼일 뽀개자!"
        case .day62:
            return "일주일 넘겨보자!"
        case .day58:
            return "절반을 향해 달려!"
        case .day32:
            return "반도 안 남았어!"
        case .day6:
            return "막판 스퍼트!"
        case .dDay:
            return "오늘이면 끝!"
        }
    }

    /// 습관방 배경 flake
    public func sparkFlakeHabitBackground() -> UIImage? {
        switch state {
        case .day66:
            return UIImage(named: "property1BgHabitroomSparkflake1")
        case .day65:
            return UIImage(named: "property1BgHabitroomSparkflake1")
        case .day62:
            return UIImage(named: "property1BgHabitroomSparkflake2")
        case .day58:
            return UIImage(named: "property1BgHabitroomSparkflake3")
        case .day32:
            return UIImage(named: "property1BgHabitroomSparkflake4")
        case .day6:
            return UIImage(named: "property1BgHabitroomSparkflake5")
        case .dDay:
            return UIImage(named: "property1BgHabitroomSparkflake6")
        }
    }
    
    /// 진행중 보관함 flake
    public func sparkFlakeGoingStorage() -> UIImage? {
        switch state {
        case .day66:
            return UIImage(named: "property1MyboxCardOngoingSparkflake1")
        case .day65:
            return UIImage(named: "property1MyboxCardOngoingSparkflake1")
        case .day62:
            return UIImage(named: "property1MyboxCardOngoingSparkflake2")
        case .day58:
            return UIImage(named: "property1MyboxCardOngoingSparkflake3")
        case .day32:
            return UIImage(named: "property1MyboxCardOngoingSparkflake4")
        case .day6:
            return UIImage(named: "property1MyboxCardOngoingSparkflake5")
        case .dDay:
            return UIImage(named: "property1MyboxCardOngoingSparkflake6")
        }
    }
    
    /// 미완료 보관함 flake
    public func sparkFlakeFailStorage() -> UIImage? {
        switch state {
        case .day66:
            return UIImage(named: "property1MyboxCardFailedSparkflake1")
        case .day65:
            return UIImage(named: "property1MyboxCardFailedSparkflake1")
        case .day62:
            return UIImage(named: "property1MyboxCardFailedSparkflake2")
        case .day58:
            return UIImage(named: "property1MyboxCardFailedSparkflake3")
        case .day32:
            return UIImage(named: "property1MyboxCardFailedSparkflake4")
        case .day6:
            return UIImage(named: "property1MyboxCardFailedSparkflake5")
        case .dDay:
            return UIImage(named: "property1MyboxCardFailedSparkflake6")
        }
    }
    
    /// 완료 보관함 flake
    public func sparkFlakeCompleteStorage() -> UIImage? {
        switch state {
        default:
            return UIImage(named: "myboxCardCompleteSparkflake")
        }
    }
    
    /// flaek color
    public func sparkFlakeColor() -> UIColor {
        switch state {
        case .day66:
            return .sparkMostLightPinkred
        case .day65:
            return .sparkMostLightPinkred
        case .day62:
            return .sparkMoreLightPinkred
        case .day58:
            return .sparkLightPinkred
        case .day32:
            return .sparkBrightPinkred
        case .day6:
            return .sparkPinkred
        case .dDay:
            return .sparkDarkPinkred
        }
    }
}
