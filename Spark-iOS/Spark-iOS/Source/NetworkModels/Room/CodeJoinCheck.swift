//
//  CodeJoinCheck.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/17.
//

import Foundation

// MARK: - Welcome
struct CodeWaiting: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: CodeWaitingData?
}

// MARK: - DataClass
struct CodeWaitingData: Codable {
    let roomID: Int
    let roomName, creatorName: String
    let createrImg: String
    let profileImgs: [String]?
    let totalNums: Int

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case roomName, creatorName, createrImg, profileImgs, totalNums
    }
}
