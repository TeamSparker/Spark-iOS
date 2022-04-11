//
//  NewNotice.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/04/08.
//

import Foundation

// MARK: - NewNotice

struct NewNotice: Codable {
    let newNotice: Bool
    
    enum CodingKeys: String, CodingKey {
        case newNotice
    }
}
