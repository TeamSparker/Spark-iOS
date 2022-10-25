//
//  FeedAPI.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/17.
//

import Foundation

import Moya

public class FeedAPI {
    
    var feedProvider: MoyaProvider<FeedService>
    public init(viewController: UIViewController) {
        feedProvider = MoyaProvider<FeedService>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    func feedFetch(lastID: Int, size: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        feedProvider.request(.feedFetch(lastID: lastID, size: size)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeFeedFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }.doCleanRequest(from: .feed)
    }
    
    private func judgeFeedFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try?
                decoder.decode(GenericResponse<Feed>.self, from: data)
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
    
    func feedLike(recordID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        feedProvider.request(.feedLike(recordID: recordID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResullt = self.judgeStatus(by: statusCode, data)
                completion(networkResullt)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        case 200:
            return .success(decodedData.message)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    func postFeedReport(recordID: Int, content: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        feedProvider.request(.feedReport(recordID: recordID, content: content)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
}
