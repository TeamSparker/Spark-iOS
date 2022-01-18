//
//  WaitingRoom.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/17.
//

import Foundation

// MARK: - WaitingRoom
struct WaitingRoom: Codable {
    let data: Waiting
}

// MARK: - Waiting
struct Waiting: Codable {
    let roomID: Int
    let roomName, roomCode: String
    let fromStart: Bool
    let reqUser: ReqUser
    let members: [Member]

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case roomName, roomCode, fromStart, reqUser, members
    }
}

// MARK: - Member
struct Member: Codable {
    let userID: Int
    let nickname: String
    let profileImg: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, profileImg
    }
}

// MARK: - ReqUser
struct ReqUser: Codable {
    let userID: Int
    let nickname: String
    let profileImg: String?
    let isPurposeSet: Bool
    let moment, purpose: String?
    let isHost: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, profileImg, isPurposeSet, moment, purpose, isHost
    }
}
