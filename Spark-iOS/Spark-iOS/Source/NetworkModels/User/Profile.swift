//
//  Profile.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/06.
//

import Foundation

// MARK: - Profile
struct Profile: Codable {
    let nickname, profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImage = "profileImg"
    }
}
