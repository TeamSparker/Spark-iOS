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
    let roomID, roomName, roomCode: String
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
    let profileImg: JSONNull?
    let isPurposeSet: Bool
    let moment, purpose: String
    let isHost: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, profileImg, isPurposeSet, moment, purpose, isHost
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

