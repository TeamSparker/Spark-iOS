//
//  MyRoomCerti.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/17.
//

import Foundation

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
