//
//  Login.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/19.
//

import Foundation

// MARK: - Login

struct Login: Codable {
    let accesstoken: String?
    let isNew: Bool
    
    enum CodingKeys: String, CodingKey {
        case accesstoken
        case isNew
    }
}
