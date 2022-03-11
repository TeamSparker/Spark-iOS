//
//  ActiveNotice.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/10.
//

import Foundation

// MARK: - ActiveNotice
struct ActiveNotice: Codable {
    let newService: Bool
    let notices: [Active]
}

// MARK: - Active
struct Active: Codable {
    let noticeID: Int
    let noticeTitle, noticeContent: String
    let noticeImg: String
    let isThumbProfile: Bool
    let day: String
    let isNew: Bool

    enum CodingKeys: String, CodingKey {
        case noticeID = "noticeId"
        case noticeTitle, noticeContent, noticeImg, isThumbProfile, day, isNew
    }
}
