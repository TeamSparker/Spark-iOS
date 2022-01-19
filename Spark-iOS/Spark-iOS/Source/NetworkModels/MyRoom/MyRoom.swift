//
//  MyRoom.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/17.
//

import Foundation

// MARK: - MyRoom
struct MyRoom: Codable {
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
