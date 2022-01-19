//
//  MyRoomService.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/17.
//

import Foundation
import Moya

enum MyRoomService {
    case myRoomFetch(roomType: String, lastID: Int, size: Int)
    case myRoomCertiFetch(roomID: Int, lastID: Int, size: Int)
}

extension MyRoomService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .myRoomFetch:
            return "/myroom"
        case .myRoomCertiFetch(let roomID, _, _):
            return "/myroom/\(roomID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myRoomFetch, .myRoomCertiFetch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .myRoomFetch(let roomType, let lastID, let size):
            return .requestParameters(parameters: ["type": roomType,
                                                   "lastid": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        case .myRoomCertiFetch(_, let lastID, let size):
            return .requestParameters(parameters: ["lastid": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .myRoomFetch, .myRoomCertiFetch:
            return Const.Header.authorizationHeader
        }
    }
}
