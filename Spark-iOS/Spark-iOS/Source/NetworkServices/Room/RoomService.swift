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
    case waitingMemberFetch(roomID: Int)
    case codeJoinCheckFetch(code: String)
    case enterRoom(roomID: Int)
}

extension RoomService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .waitingFetch(let roomID):
            return "/room/\(roomID)/waiting"
        case .waitingMemberFetch(let roomID):
            return "/room/\(roomID)/waiting/member"
        case .codeJoinCheckFetch(let code):
            return "/room/code/\(code)"
        case .enterRoom(let roomID):
            return "/room/\(roomID)/enter"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .waitingFetch, .codeJoinCheckFetch:
            return .get
        case .waitingMemberFetch:
            return .get
        case .enterRoom:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .waitingFetch, .codeJoinCheckFetch:
            return .requestPlain
        case .waitingMemberFetch:
            return .requestPlain
        case .enterRoom(let roomID):
            return .requestParameters(parameters:["roomId": roomID], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .waitingFetch, .codeJoinCheckFetch, .enterRoom:
            return Const.Header.authrizationHeader
        case .waitingMemberFetch:
            return Const.Header.authrizationHeader
        }
    }
}
