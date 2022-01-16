//
//  RoomService.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/17.
//

import Foundation

import Moya

enum RoomService {
    case waitingFetch(roomID: Int)
    case codeJoinCheckFetch(code: String)
}

extension RoomService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .waitingFetch(let roomID):
            return "/room/\(roomID)/waiting"
        case .codeJoinCheckFetch(let code):
            return "/room/code/\(code)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .waitingFetch, .codeJoinCheckFetch:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .waitingFetch, .codeJoinCheckFetch:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .waitingFetch, .codeJoinCheckFetch:
            return Const.Header.authrizationHeader
        }
    }
}
