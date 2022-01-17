//
//  FeedService.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/17.
//

import Foundation

import Moya

enum FeedService {
    case feedFetch(lastID: Int, size: Int)
}

extension FeedService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .feedFetch:
            return "/feed"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .feedFetch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .feedFetch(let lastID, let size):
            return .requestParameters(parameters: ["lastid": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .feedFetch:
            return Const.Header.authrizationHeader
        }
    }
}
