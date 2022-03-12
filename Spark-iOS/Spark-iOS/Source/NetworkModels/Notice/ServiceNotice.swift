//
//  ServiceNotice.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/11.
//

import Foundation

// MARK: - DataClass
struct ServiceNotice: Codable {
    let newActive: Bool
    let notices: [Service]
}

// MARK: - Notice
struct Service: Codable {
    let noticeID: Int
    let noticeTitle: String
    let noticeContent: String
    let day: String
    let isNew: Bool

    enum CodingKeys: String, CodingKey {
        case noticeID = "noticeId"
        case noticeTitle, noticeContent, day, isNew
    }
}
