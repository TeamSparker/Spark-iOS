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
        static func basicHeader() -> [String: String] {
            ["Content-Type": "application/json"]
        }
        
        /// "Content-Type": "application/json" 과 access token 을 헤더에 담아서 보내야하는 경우에 사용.
        static func authorizationHeader() -> [String: String] {
            ["Content-Type": "application/json",
                                              "Authorization": UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) ?? ""]
        }
        
        /// "Content-Type": "multipart/form-data"
        static func multipartHeader() -> [String: String] {
            ["Content-Type": "multipart/form-data"]
        }
        
        /// "Content-Type": "multipart/form-data" 과 access token 을 헤더에 담아서 보내야하는 경우에 사용.
        static func multipartAuthorizationHeader() -> [String: String] {
            ["Content-Type": "multipart/form-data",
                                                       "Authorization": UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) ?? ""]
        }
    }
}
