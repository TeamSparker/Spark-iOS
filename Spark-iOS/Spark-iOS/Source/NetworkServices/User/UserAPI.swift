//
//  UserAPI.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/04.
//

import Foundation

import Moya

public class UserAPI {
    var userProvider: MoyaProvider<UserService>
    
    public init(viewController: UIViewController) {
        userProvider = MoyaProvider<UserService>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    func profileFetch(completion: @escaping(NetworkResult<Any>) -> Void) {
        userProvider.request(.profileFetch) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgePofileFetchStatus(by: statusCode, data)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgePofileFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Profile>.self, from: data)
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
    
    func profileEdit(profileImage: UIImage?, nickname: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        userProvider.request(.profileEdit(profileImage: profileImage, nickname: nickname)) { result in
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
