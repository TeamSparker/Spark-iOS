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
    case myRoomChangeThumbnail(roomId: Int, recordId: Int)
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
        case .myRoomChangeThumbnail(let roomId, let recordId):
            return "/myroom/\(roomId)/thumbnail/\(recordId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myRoomFetch:
            return .get
        case .myRoomCertiFetch:
            return .get
        case .myRoomChangeThumbnail:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .myRoomFetch(let roomType, let lastID, let size):
            return .requestParameters(parameters: ["type": roomType,
                                                   "lastId": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        case .myRoomCertiFetch(_, let lastID, let size):
            return .requestParameters(parameters: ["lastId": lastID,
                                                   "size": size],
                                      encoding: URLEncoding.queryString)
        case .myRoomChangeThumbnail:
            return  .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .myRoomFetch:
            return Const.Header.authorizationHeader()
        case .myRoomCertiFetch:
            return Const.Header.authorizationHeader()
        case .myRoomChangeThumbnail:
            return Const.Header.authorizationHeader()
        }
    }
}
