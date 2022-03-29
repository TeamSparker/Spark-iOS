//
//  NoticeSetting.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/28.
//

import Foundation

// MARK: - NoticeSetting

struct NoticeSetting: Codable {
    let roomStart: Bool
    let spark: Bool
    let consider: Bool
    let certification: Bool
    let remind: Bool
    
    enum CodingKeys: String, CodingKey {
        case roomStart, spark, consider, certification, remind
    }
}
