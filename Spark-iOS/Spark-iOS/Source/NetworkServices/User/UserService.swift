//
//  UserService.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/04.
//

import Foundation

import Moya
import UIKit

enum UserService {
    case profileFetch
    case profileEdit(profileImage: UIImage?, nickname: String)
}

extension UserService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        return "/user/profile"
    }
    
    var method: Moya.Method {
        switch self {
        case .profileFetch:
            return .get
        case .profileEdit:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .profileFetch:
            return .requestPlain
        case .profileEdit(let profileImage, let nickname):
            var multiPartData: [Moya.MultipartFormData] = []
            
            let nickname = nickname.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(nickname), name: "nickname"))
            if let profileImage = profileImage {
                let profileImageData = MultipartFormData(provider: .data(profileImage.pngData() ?? Data()), name: "image", fileName: "image.png", mimeType: "image/png")
                multiPartData.append(profileImageData)
            }
            
            return .uploadMultipart(multiPartData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .profileFetch:
            return Const.Header.authorizationHeader()
        case .profileEdit:
            return Const.Header.multipartAuthorizationHeader()
        }
    }
}
