//
//  Login.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/19.
//

import Foundation

// MARK: - Login

struct Login: Codable {
    let accesstoken: Accesstoken
    
    enum CodingKeys: String, CodingKey {
        case accesstoken
    }
}

// MARK: - Accesstoken

struct Accesstoken: Codable {
    let accesstoken: String
    
    enum CodingKeys: String, CodingKey {
        case accesstoken
    }
}
