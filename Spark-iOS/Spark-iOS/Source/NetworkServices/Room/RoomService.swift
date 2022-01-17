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
    case authUpload(roomID: Int, timer: String, image: UIImage)
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
        case .authUpload(let roomID, _, _):
            return "/room/\(roomID)/record"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .waitingFetch:
            return .get
        case .codeJoinCheckFetch:
            return .get
        case .waitingMemberFetch:
            return .get
        case .enterRoom, .authUpload:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .waitingFetch:
            return .requestPlain
        case .codeJoinCheckFetch:
            return .requestPlain
        case .waitingMemberFetch:
            return .requestPlain
        case .enterRoom(let roomID):
            return .requestParameters(parameters: ["roomId": roomID], encoding: JSONEncoding.default)
        case .authUpload(_, let timer, let image):
            var multiPartData: [Moya.MultipartFormData] = []
            
            let timerData = timer.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(timerData), name: "timerRecord"))
            
            let imageData = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 1) ?? Data()), name: "image", fileName: "image", mimeType: "image/jpeg")
            multiPartData.append(imageData)
            
            return .uploadMultipart(multiPartData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .waitingFetch:
            return Const.Header.authrizationHeader
        case .codeJoinCheckFetch:
            return Const.Header.authrizationHeader
        case .enterRoom:
            return Const.Header.authrizationHeader
        case .waitingMemberFetch:
            return Const.Header.authrizationHeader
        case .authUpload:
            return Const.Header.authrizationHeader
        }
    }
}
