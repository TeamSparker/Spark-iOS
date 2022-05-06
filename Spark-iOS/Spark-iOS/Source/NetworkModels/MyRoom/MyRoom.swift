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
    let rooms: [MyRoomRooms]?
}

// MARK: - Rooms
struct MyRoomRooms: Codable {
    let roomID: Int
    let roomName: String
    let leftDay: Int
    let thumbnail: String
    let totalReceivedSpark: Int
    let startDate, endDate: String
    let failDay: Int?
    let comment: String?

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case roomName, leftDay, thumbnail, totalReceivedSpark, startDate, endDate, failDay, comment
    }
}
