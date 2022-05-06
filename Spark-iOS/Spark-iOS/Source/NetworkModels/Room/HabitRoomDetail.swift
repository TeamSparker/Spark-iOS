//
//  HabitRoomDetail.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/19.
//

import Foundation

// MARK: - HabitRoom

struct HabitRoomDetail: Codable {
    let roomID: Int
    let roomName, startDate, endDate: String
    let moment, purpose: String?
    let leftDay, life: Int
    let fromStart: Bool
    let lifeDeductionCount: Int
    let myRecord: MyRecord
    let otherRecords: [OtherRecord?]

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case roomName, startDate, endDate, moment, purpose, leftDay, life, fromStart, myRecord, otherRecords, lifeDeductionCount
    }
}

// MARK: - MyRecord

struct MyRecord: Codable {
    let recordID, userID: Int
    let profileImg: String?
    let nickname, status: String
    let rest, receivedSpark: Int

    enum CodingKeys: String, CodingKey {
        case recordID = "recordId"
        case userID = "userId"
        case profileImg, nickname, status, rest, receivedSpark
    }
}

// MARK: - OtherRecord

struct OtherRecord: Codable {
    let recordID, userID: Int
    let profileImg: String
    let nickname, status: String

    enum CodingKeys: String, CodingKey {
        case recordID = "recordId"
        case userID = "userId"
        case profileImg, nickname, status
    }
}
