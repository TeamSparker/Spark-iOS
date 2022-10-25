//
//  HomeAPI.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/15.
//

import Foundation
import Moya

public class HomeAPI {
    var userProvider: MoyaProvider<HomeService>
    
    public init(viewController: UIViewController) {
        userProvider = MoyaProvider<HomeService>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    func habitRoomFetch(lastID: Int, size: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.habitRoomFetch(lastID: lastID, size: size)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeHabitRoomFetchStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }.doCleanRequest(from: .home)
    }
    
    private func judgeHabitRoomFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<HabitRoom>.self, from: data)
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
    
    /// 응답 시 data 가 없는 경우.
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
}
