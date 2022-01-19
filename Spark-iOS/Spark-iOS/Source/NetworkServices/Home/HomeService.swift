//
//  HomeService.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/15.
//

import Foundation
import Moya

enum HomeService {
    case habitRoomFetch(lastID: Int, size: Int)
}

extension HomeService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .habitRoomFetch:
            return "/room"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .habitRoomFetch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .habitRoomFetch(let lastID, let size):
            return .requestParameters(parameters: ["lastid": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .habitRoomFetch:
            return Const.Header.authorizationHeader
        }
    }
}
