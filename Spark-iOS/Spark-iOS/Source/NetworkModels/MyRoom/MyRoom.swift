//
//  MyRoom.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/17.
//

import Foundation

// MARK: - MyRoom
struct MyRoom: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: MyRoomData
}

// MARK: - DataClass
struct MyRoomData: Codable {
    let nickname: String
    let totalRoomNum, ongoingRoomNum, completeRoomNum, failRoomNum: Int
    let rooms: [Rooms]?
}

// MARK: - Rooms
struct Rooms: Codable {
    let roomID: Int
    let roomName: String
    let leftDay: Int
    let thumbnail: String
    let totalRecievedSpark: Int
    let startDate, endDate: String
    let failDay: Int?
    let comment: String?

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case roomName, leftDay, thumbnail, totalRecievedSpark, startDate, endDate, failDay, comment
    }
}

// MARK: - MyRoomCerti
struct MyRoomCerti: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: MyRoomCertiData
}

// MARK: - MyRoomCertiData
struct MyRoomCertiData: Codable {
    let roomName: String
    let records: [CertiRecord]?
}

// MARK: - CertiRecord
struct CertiRecord: Codable {
    let recordID: Int
    let leftDay: Int?
    let certifyingImg: String?
    let sparkNum: Int
    let status: String

    enum CodingKeys: String, CodingKey {
        case recordID = "recordId"
        case leftDay, certifyingImg, sparkNum, status
    }
}
