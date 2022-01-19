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
                             "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjc5LCJpYXQiOjE2NDI1ODY0MzgsImV4cCI6MTY0NTE3ODQzOCwiaXNzIjoic3BhcmsifQ.VDuAII0RON698MZgAmh_alup8kEOBWyYpjeA37geikE"]
//        static var authorizationHeader = ["Content-Type": "application/json",
//                                         "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjcxLCJpYXQiOjE2NDI1NzU5MjksImV4cCI6MTY0NTE2NzkyOSwiaXNzIjoic3BhcmsifQ.na6paylY4-2dGBLcTtalxaJc-Xt380MnqSJV2JyC64I"]
        static let multipartHeader = ["Content-Type": "multipart/form-data"]
        static let multipartAuthorizationHeader = ["Content-Type": "multipart/form-data",
                                                   "Authorization": accessToken]
    }
}
