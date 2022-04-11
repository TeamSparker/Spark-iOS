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
    
    private init() { }
    
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
    
    func serviceFetch(lastID: Int, size: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        noticeProvider.request(.serviceFetch(lastID: lastID, size: size)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeServiceFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case . failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeServiceFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<ServiceNotice>.self, from: data)
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
    
    func activeRead(completion: @escaping(NetworkResult<Any>) -> Void) {
        noticeProvider.request(.activeRead) { result in
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
    
    func serviceRead(completion: @escaping(NetworkResult<Any>) -> Void) {
        noticeProvider.request(.serviceRead) { result in
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
    
    func settingFetch(completion: @escaping(NetworkResult<Any>) -> Void) {
        noticeProvider.request(.settingFetch) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeSettingFetchStatus(by: statusCode, data)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeSettingFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<NoticeSetting>.self, from: data)
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
    
    func settingPatch(category: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        noticeProvider.request(.settingPatch(category: category)) { result in
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
    
    func newNoticeFetch(completion: @escaping(NetworkResult<Any>) -> Void) {
        noticeProvider.request(.newNoticeFetch) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judegNewNoticeFetchStatus(by: statusCode, data)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judegNewNoticeFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<NewNotice>.self, from: data)
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
