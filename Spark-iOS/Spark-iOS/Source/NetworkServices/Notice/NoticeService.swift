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
    case activeRead
    case serviceRead
    case settingFetch
    case settingPatch(category: String)
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
        case .activeRead:
            return "/notice/active/read"
        case .serviceRead:
            return "/notice/service/read"
        case .settingFetch:
            return "/notice/setting"
        case .settingPatch:
            return "/notice/setting"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .activeFetch:
            return .get
        case .serviceFetch:
            return .get
        case .activeRead:
            return .patch
        case .serviceRead:
            return .patch
        case .settingFetch:
            return .get
        case .settingPatch:
            return .patch
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
        case .activeRead:
            return .requestPlain
        case .serviceRead:
            return .requestPlain
        case .settingFetch:
            return .requestPlain
        case .settingPatch(category: let category):
            return .requestParameters(parameters: ["category": category],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .activeFetch:
            return Const.Header.authorizationHeader
        case .serviceFetch:
            return Const.Header.authorizationHeader
        case .activeRead:
            return Const.Header.authorizationHeader
        case .serviceRead:
            return Const.Header.authorizationHeader
        case .settingFetch:
            return Const.Header.authorizationHeader
        case .settingPatch:
            return Const.Header.authorizationHeader
        }
    }
}
