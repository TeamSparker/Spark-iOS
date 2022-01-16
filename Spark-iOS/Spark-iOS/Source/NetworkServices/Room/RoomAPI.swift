//
//  RoomAPI.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/17.
//

import Foundation

import Moya

public class RoomAPI {
    
    static let shared = RoomAPI()
    var roomProvider = MoyaProvider<RoomService>(plugins: [MoyaLoggerPlugin()])
    
    public init() { }

    func waitingFetch(roomID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.waitingFetch(roomID: roomID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                print("한번만")
                
                let networkResult = self.judgeWaitingFetchStatus(by: statusCode, data)
                print("networkresult", networkResult)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeWaitingFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try?
                decoder.decode(GenericResponse<Waiting>.self, from: data)
        else { return .pathErr }
        
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
