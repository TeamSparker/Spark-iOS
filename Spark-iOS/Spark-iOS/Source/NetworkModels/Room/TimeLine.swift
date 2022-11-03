//
//  TimeLine.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/10/07.
//

import Foundation

// MARK: - Timelines
struct Timelines: Codable {
    let timelines: [Timeline]
}

// MARK: - Timeline
struct Timeline: Codable {
    let title, content: String
    let profiles: [String]?
    let day: String
    let isNew: Bool
}
