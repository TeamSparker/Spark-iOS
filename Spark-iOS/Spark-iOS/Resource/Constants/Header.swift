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
                                         "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIxLCJpYXQiOjE2NDE5NTk1MTUsImV4cCI6MTY0NDU1MTUxNSwiaXNzIjoid2Vzb3B0In0.MT_7RGrTbk8DRve87CkZbwKRw3f1T8NyF3CSE0yXLP4"]
    }
}
