//
//  NoticeAPI.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/10.
//

import Foundation

import Moya

public class NoticeAPI {
    
    static let shared = NoticeAPI()
    var noticeProvider = MoyaProvider<NoticeService>(plugins: [MoyaLoggerPlugin()])
    
    public init() { }
    
//    func activeFetch(lastID: Int, size: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
//
//    }
}
