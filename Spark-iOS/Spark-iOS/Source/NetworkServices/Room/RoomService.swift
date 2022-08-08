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
    case createRoom(createRoom: CreateRoom)
    case sendSpark(roomID: Int, recordID: Int, content: String)
    case startRoom(roomID: Int)
    case setConsiderRest(roomID: Int, statusType: String)
    case habitRoomDetailFetch(roomID: Int)
    case setPurpose(roomID: Int, moment: String, purpose: String)
    case deleteWaitingRoom(roomID: Int)
    case leaveRoom(roomID: Int)
    case readRoom(roomID: Int)
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
        case .createRoom:
            return "/room"
        case .sendSpark(let roomID, _, _):
            return "/room/\(roomID)/spark"
        case .startRoom(let roomID):
            return "/room/\(roomID)/start"
        case .setConsiderRest(let roomID, _):
            return "/room/\(roomID)/status"
        case .habitRoomDetailFetch(let roomID):
            return "/room/\(roomID)"
        case .setPurpose(let roomID, _, _):
            return "/room/\(roomID)/purpose"
        case .deleteWaitingRoom(let roomID):
            return "/room/\(roomID)/"
        case .leaveRoom(let roomID):
            return "/room/\(roomID)/out"
        case .readRoom(let roomID):
            return "/room/\(roomID)/read"
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
        case .enterRoom:
            return .post
        case .authUpload:
            return .post
        case .createRoom:
            return .post
        case .sendSpark:
            return .post
        case .startRoom:
            return .post
        case .setConsiderRest:
            return .post
        case .habitRoomDetailFetch:
            return .get
        case .setPurpose:
            return .patch
        case .deleteWaitingRoom:
            return .delete
        case .leaveRoom:
            return .delete
        case .readRoom:
            return .patch
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
            
            let imageData = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0.5) ?? Data()), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            multiPartData.append(imageData)
            
            return .uploadMultipart(multiPartData)
        case .createRoom(let createRoom):
            return .requestJSONEncodable(createRoom)
        case .sendSpark(_, let recordID, let content):
            return .requestParameters(parameters: ["content": content, "recordId": recordID], encoding: JSONEncoding.default)
        case .startRoom(let roomID):
            return .requestParameters(parameters: ["roomId": roomID],
                                      encoding: URLEncoding.queryString)
        case .setConsiderRest(_, let statusType):
            return .requestParameters(parameters: ["statusType": statusType], encoding: JSONEncoding.default)
        case .habitRoomDetailFetch:
            return .requestPlain
        case .setPurpose(_, let moment, let purpose):
            return .requestParameters(parameters: ["moment": moment, "purpose": purpose],
                                      encoding: JSONEncoding.default)
        case .deleteWaitingRoom(let roomID):
            return .requestParameters(parameters: ["roomId": roomID], encoding: JSONEncoding.default)
        case .leaveRoom(let roomID):
            return .requestParameters(parameters: ["roomId": roomID], encoding: JSONEncoding.default)
        case .readRoom:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .waitingFetch:
            return Const.Header.authorizationHeader()
        case .codeJoinCheckFetch:
            return Const.Header.authorizationHeader()
        case .enterRoom:
            return Const.Header.authorizationHeader()
        case .waitingMemberFetch:
            return Const.Header.authorizationHeader()
        case .authUpload:
            return Const.Header.multipartAuthorizationHeader()
        case .createRoom:
            return Const.Header.authorizationHeader()
        case .sendSpark:
            return Const.Header.authorizationHeader()
        case .startRoom:
            return Const.Header.authorizationHeader()
        case .setConsiderRest:
            return Const.Header.authorizationHeader()
        case .habitRoomDetailFetch:
            return Const.Header.authorizationHeader()
        case .setPurpose:
            return Const.Header.authorizationHeader()
        case .deleteWaitingRoom:
            return Const.Header.authorizationHeader()
        case .leaveRoom:
            return Const.Header.authorizationHeader()
        case .readRoom:
            return Const.Header.authorizationHeader()
        }
    }
}
