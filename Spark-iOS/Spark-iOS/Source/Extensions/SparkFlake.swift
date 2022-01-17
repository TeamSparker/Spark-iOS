//
//  SparkFlake.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/17.
//

import Foundation
import UIKit

@frozen
enum SparkFlake {
    case day66
    case day59
    case day33
    case day7
    case day3
    case day1
}

extension SparkFlake {
    func sparkFlakeTicket() -> UIImage? {
        switch self {
        case .day66:
            return UIImage(named: "property1TicketLeftSparkflake14")
        case .day59:
            return UIImage(named: "property1TicketLeftSparkflake24")
        case .day33:
            return UIImage(named: "property1TicketLeftSparkflake34")
        case .day7:
            return UIImage(named: "property1TicketLeftSparkflake44")
        case .day3:
            return UIImage(named: "property1TicketLeftSparkflake54")
        case .day1:
            return UIImage(named: "property1TicketLeftSparkflake64")
        }
    }
    
//    func sparkFlakeMent() -> String {
//        switch self {
//        case .day59:
//            return "시작이 반이다."
//        case .day59:
//            return UIImage(named: "작심삼일 돌파!")
//        case .day33:
//            return UIImage(named: "시작한지 일주일!")
//        case .day7:
//            return UIImage(named: "property1TicketLeftSparkflake44")
//        case .day3:
//            return UIImage(named: "property1TicketLeftSparkflake54")
//        case .day1:
//            return UIImage(named: "property1TicketLeftSparkflake64")
//        }
//    }

    func sparkFlakeHabitBackground() -> UIImage? {
        switch self {
        case .day66:
            return UIImage(named: <#T##String#>)
        case .day59:
            return UIImage(named: <#T##String#>)
        case .day33:
            return UIImage(named: <#T##String#>)
        case .day7:
            return UIImage(named: <#T##String#>)
        case .day3:
            return UIImage(named: <#T##String#>)
        case .day1:
            return UIImage(named: <#T##String#>)
        }
    }
}
