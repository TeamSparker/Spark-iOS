//
//  CreateRoom.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/18.
//

import Foundation

// MARK: - CreateRoom
struct CreateRoom: Codable {
    let roomName: String
    let fromStart: Bool
    
    enum CodingKeys: String, CodingKey {
        case roomName, fromStart
    }
}
