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
    
    public init() { }
    
    func signup(socailID: String, profileImg: UIImage, nickname: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.signup(socialId: socailID, profileImg: profileImg, nickname: nickname)) { result in
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
