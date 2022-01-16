//
//  GenericResponse.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/15.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let statusCode: Int
    let success, message: String
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case statusCode, success, message, data
    }
}
