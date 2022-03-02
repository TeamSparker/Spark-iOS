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
struct Member: Codable, Hashable {
    let userID: Int
    let nickname: String
    let profileImg: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, profileImg
    }
    
    /// struct를 hashable로 변환.
    /// hashValue가 고유값인지 식별해주는 함수 (Equatable protocol)
    static func == (lhs: Member, rhs: Member) -> Bool {
        lhs.userID == rhs.userID
    }
    
    /// combine 메소드를 통해 식별할 수 있는 identifier 값 전달
    /// hasher이 hashValue를 생성해줌.
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
}

// MARK: - ReqUser
struct ReqUser: Codable {
    let userID: Int
    let nickname: String
    let profileImg: String
    let isPurposeSet: Bool
    let moment, purpose: String?
    let isHost: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, profileImg, isPurposeSet, moment, purpose, isHost
    }
}
