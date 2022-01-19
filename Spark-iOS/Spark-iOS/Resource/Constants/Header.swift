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
        static var basicHeader = ["Content-Type": "application/json"]
        /// access token 을 헤더에 담아서 보내야하는 경우에 사용.
//        static var authrizationHeader = ["Content-Type": "application/json",
//                             "Authorization": accessToken]
        static var authrizationHeader = ["Content-Type": "application/json",
                                         "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjcxLCJpYXQiOjE2NDI1NzU5MjksImV4cCI6MTY0NTE2NzkyOSwiaXNzIjoic3BhcmsifQ.na6paylY4-2dGBLcTtalxaJc-Xt380MnqSJV2JyC64I"]
    }
}
