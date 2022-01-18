//
//  Signup.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/18.
//

import Foundation
import UIKit

// MARK: - DataClass
struct Signup: Codable {
    let user: User
    let accesstoken: String
}

// MARK: - User
struct User: Codable {
    let userID: Int
    let nickname: String
    let profileImg: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, profileImg
    }
}
