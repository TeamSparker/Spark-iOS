//
//  AuthAPI.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/18.
//

import Foundation
import Moya

public class AuthAPI {
    
    static let shared = AuthAPI()
    var userProvider = MoyaProvider<AuthService>(plugins: [MoyaLoggerPlugin()])
    
    // 객체화할 수 없게 만들어서 싱글톤 패턴으로만 사용하도록 접근 제어자 설정.
    private init() { }
    
    func signup(socialID: String, profileImg: UIImage, nickname: String, fcmToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.signup(socialID: socialID, profileImg: profileImg, nickname: nickname, fcmToken: fcmToken)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeSignupStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func login(socialID: String, fcmToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.login(socialID: socialID, fcmToken: fcmToken)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeLoginStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeLoginStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Login>.self, from: data)
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
    
    private func judgeSignupStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Signup>.self, from: data)
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
