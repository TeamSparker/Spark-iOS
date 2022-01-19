//
//  MyRoomCerti.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/17.
//

import Foundation

// MARK: - MyRoomCertiData
struct MyRoomCertification: Codable {
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
