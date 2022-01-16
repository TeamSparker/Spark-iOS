//
//  MyRoomService.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/17.
//

import Foundation
import Moya

enum MyRoomService {
    case myRoomFetch(lastID: Int, size: Int)
}

extension MyRoomService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .myRoomFetch:
            return "/myroom?type=&lastid=&size="
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myRoomFetch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .myRoomFetch(let lastID, let size):
            return .requestParameters(parameters: ["lastid": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .myRoomFetch:
            return Const.Header.authrizationHeader
        }
    }
}
