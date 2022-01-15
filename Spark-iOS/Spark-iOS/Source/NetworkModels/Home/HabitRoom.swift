//
//  HabitRoom.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/15.
//

import Foundation

// MARK: - HabitRoom
struct HabitRoom: Codable {
    let rooms: [Room]
}

// MARK: - Room
struct Room: Codable {
    let roomID: Int
    let roomName: String
    let leftDay: Int?
    let profileImg: [String]?
    let life: Int?
    // isStarted: 습관방 시작했는지 여부. isDone: 인증 완료 여부.
    let isStarted, isDone: Bool
    let memberNum, doneMemberNum: Int?

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case roomName, leftDay, profileImg, life, isStarted, isDone, memberNum, doneMemberNum
    }
}
