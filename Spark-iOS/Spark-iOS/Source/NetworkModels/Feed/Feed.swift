//
//  Feed.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/17.
//

import Foundation

// MARK: - Feed
struct Feed: Codable {
    let records: [Record]
}

// MARK: - Record
struct Record: Codable {
    let date, day: String
    let userID, recordID: Int
    let nickname: String
    let profileImg: String?
    let roomName: String
    let certifyingImg: String?
    var likeNum: Int
    let sparkCount: Int
    var isLiked: Bool
    let timerRecord: String?

    enum CodingKeys: String, CodingKey {
        case date, day
        case userID = "userId"
        case recordID = "recordId"
        case nickname, profileImg, certifyingImg, likeNum, sparkCount, isLiked, timerRecord, roomName
    }
}
