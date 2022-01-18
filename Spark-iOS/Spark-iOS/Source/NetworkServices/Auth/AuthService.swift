//
//  AuthService.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/18.
//

import Foundation
import Moya

enum AuthService {
    case signup(socialId: String, profileImg: UIImage, nickname: String)
}

extension AuthService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/auth/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signup(let socialID, let profileImg, let nickname):
            var multiPartData: [Moya.MultipartFormData] = []
            
            let socialIDData = socialID.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(socialIDData), name: "socialId"))
            let nicknameData = nickname.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(nicknameData), name: "nickname"))
            
            let profileImgData = MultipartFormData(provider: .data(profileImg.pngData() ?? Data()), name: "profileImg", fileName: "image.png", mimeType: "image/png")
            multiPartData.append(profileImgData)
            
            return .uploadMultipart(multiPartData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signup:
            return Const.Header.authrizationHeader
        }
    }
}
