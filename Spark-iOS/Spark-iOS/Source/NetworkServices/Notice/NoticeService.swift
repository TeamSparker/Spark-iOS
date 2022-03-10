//
//  NoticeService.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/10.
//

import Foundation

import Moya

enum NoticeService {
    case activeFetch(lastID: Int, size: Int)
    case serviceFetch(lastID: Int, size: Int)
}

extension NoticeService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .activeFetch:
            return "/notice/active"
        case .serviceFetch:
            return "/notice/service"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .activeFetch:
            return .get
        case .serviceFetch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .activeFetch(lastID: let lastID, size: let size):
            return .requestParameters(parameters: ["lastId": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        case .serviceFetch(lastID: let lastID, size: let size):
            return .requestParameters(parameters: ["lastId": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .activeFetch:
            return Const.Header.authorizationHeader
        case .serviceFetch:
            return Const.Header.authorizationHeader
        }
    }
}
