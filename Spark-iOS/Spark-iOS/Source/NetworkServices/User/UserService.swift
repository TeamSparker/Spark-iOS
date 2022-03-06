//
//  UserService.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/04.
//

import Foundation

import Moya

enum UserService {
    case profileFetch
    case profileEdit
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
        return .requestPlain
    }
    
    var headers: [String: String]? {
        switch self {
        case .profileFetch:
            return Const.Header.authorizationHeader
        case .profileEdit:
            return Const.Header.multipartAuthorizationHeader
        }
    }
}
