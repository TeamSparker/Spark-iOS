//
//  Header.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/15.
//

import Foundation

extension Const {
    struct Header {
        /// Content-Type: application/json
        static let basicHeader = ["Content-Type": "application/json"]
        /// access token 을 헤더에 담아서 보내야하는 경우에 사용.
        static let authorizationHeader = ["Content-Type": "application/json",
                                          "Authorization": accessToken]
        
        static let multipartHeader = ["Content-Type": "multipart/form-data"]
        static let multipartAuthorizationHeader = ["Content-Type": "multipart/form-data",
                                                   "Authorization": accessToken]
    }
}
