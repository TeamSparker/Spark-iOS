//
//  AuthUpload.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/18.
//

import Foundation

// MARK: - AuthUpload
struct AuthUpload: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: AuthUploadData?
}

// MARK: - DataClass
struct AuthUploadData: Codable {
    let userID: Int
    let nickname: String
    let profileImg: String?
    let roomID: Int
    let roomName: String
    let recordID, day: Int
    let certifyingImg: String?
    let timerRecord: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, profileImg
        case roomID = "roomId"
        case roomName
        case recordID = "recordId"
        case day, certifyingImg, timerRecord
    }
}
