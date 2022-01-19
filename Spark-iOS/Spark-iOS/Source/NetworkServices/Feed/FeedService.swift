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
    case feedLike(recordID: Int)
}

extension FeedService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .feedFetch:
            return "/feed"
        case .feedLike(let recordID):
            return "/feed/\(recordID)/like"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .feedFetch:
            return .get
        case .feedLike:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .feedFetch(let lastID, let size):
            return .requestParameters(parameters: ["lastid": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        case .feedLike(let recordID):
            return .requestParameters(parameters: ["recordId": recordID],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .feedFetch:
            return Const.Header.authorizationHeader
        case .feedLike:
            return Const.Header.authorizationHeader
        }
    }
}
