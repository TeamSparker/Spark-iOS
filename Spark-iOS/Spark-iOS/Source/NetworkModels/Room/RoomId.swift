//
//  RoomId.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/18.
//

import Foundation

// MARK: - RoomId
struct RoomId: Codable {
    let roomID: Int

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
    }
}
