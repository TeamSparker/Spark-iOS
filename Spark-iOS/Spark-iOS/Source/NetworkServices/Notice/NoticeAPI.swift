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
    
    func activeFetch(lastID: Int, size: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        noticeProvider.request(.activeFetch(lastID: lastID, size: size)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeActiveFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case . failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeActiveFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<ActiveNotice>.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
