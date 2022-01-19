//
//  RoomAPI.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/17.
//

import Foundation

import Moya
import UIKit

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
                let networkResult = self.judgeWaitingFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func waitingMemberFetch(roomID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.waitingMemberFetch(roomID: roomID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeWaitingMembersFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeWaitingFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Waiting>.self, from: data)
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
    
    private func judgeWaitingMembersFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<WaitingMember>.self, from: data)
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
    
    func codeJoinCheckFetch(code: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.codeJoinCheckFetch(code: code)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeCodeJoinCheckFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeCodeJoinCheckFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CodeWaiting>.self, from: data)
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
    
    func enterRoom(roomID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.enterRoom(roomID: roomID)) { result in
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
    
    func createRoom(createRoom: CreateRoom, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.createRoom(createRoom: createRoom)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeCreateStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func startRoomWithAPI(roomID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.startRoom(roomID: roomID)) { result in
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
    
    private func judgeCreateStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<RoomId>.self, from: data)
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
    
    func authUpload(roomID: Int, timer: String, image: UIImage, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.authUpload(roomID: roomID, timer: timer, image: image)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeAuthUploadStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeAuthUploadStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try?
                decoder.decode(GenericResponse<AuthUpload>.self, from: data)
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
    
    func sendSpark(roomID: Int, recordID: Int, content: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.sendSpark(roomID: roomID, recordID: recordID, content: content)) { result in
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
    
    func setConsiderRest(roomID: Int, statusType: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.setConsiderRest(roomID: roomID, statusType: statusType)) { result in
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
    
    func setPurpose(roomID: Int, moment: String, purpose: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.setPurpose(roomID: roomID, moment: moment, purpose: purpose)) { result in
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
    
    func fetchHabitRoomDetail(roomID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        roomProvider.request(.habitRoomDetailFetch(roomID: roomID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeFetchHabitRoomDetailStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeFetchHabitRoomDetailStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<HabitRoomDetail>.self, from: data)
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
