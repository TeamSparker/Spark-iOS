//
//  WaitingMember.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/17.
//

import Foundation

// MARK: - Members
struct WaitingMember: Codable {
    let members: [Member]
    
    enum CodingKeys: String, CodingKey {
        case members
    }
}
