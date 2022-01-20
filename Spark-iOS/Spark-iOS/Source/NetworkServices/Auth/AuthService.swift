//
//  AuthService.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/18.
//

import Foundation
import Moya

enum AuthService {
    case signup(socialID: String, profileImg: UIImage?, nickname: String, fcmToken: String)
    case login(socialID: String, fcmToken: String)
}

extension AuthService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/auth/signup"
        case .login:
            return "/auth/doorbell"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup:
            return .post
        case .login:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .signup(let socialID, let profileImg, let nickname, let fcmToken):
            var multiPartData: [Moya.MultipartFormData] = []
            
            let socialIDData = socialID.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(socialIDData), name: "socialId"))
            let nicknameData = nickname.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(nicknameData), name: "nickname"))
            let fcmTokenData = fcmToken.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(fcmTokenData), name: "fcmToken"))
            if let profileImg = profileImg {
                let profileImgData = MultipartFormData(provider: .data(profileImg.pngData() ?? Data()), name: "image", fileName: "image.png", mimeType: "image/png")
                multiPartData.append(profileImgData)
            }
            
            return .uploadMultipart(multiPartData)
        case .login(let socialID, let fcmToken):
            return .requestParameters(parameters: ["socialId": socialID,
                                                   "fcmToken": fcmToken],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signup:
            return Const.Header.basicHeader
        case .login:
            return Const.Header.basicHeader
        }
    }
}
