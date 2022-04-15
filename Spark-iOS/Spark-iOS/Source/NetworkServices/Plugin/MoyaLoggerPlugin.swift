//
//  MoyaLoggerPlugin.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/15.
//

import Foundation
import UIKit

import Moya

final class MoyaLoggerPlugin: PluginType {
    
    private let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // Request를 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("--> 유효하지 않은 요청")
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "----------------------------------------------------\n1️⃣[\(method)] \(url)\n----------------------------------------------------\n"
        log.append("2️⃣API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("header: \(headers)\n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("\(bodyString)\n")
        }
        log.append("------------------- END \(method) -------------------")
        print(log)
    }
    
    // Response가 왔을 때
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSucceed(response)
        case let .failure(error):
            onFail(error)
        }
    }
    
    func onSucceed(_ response: Response) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "------------------- 네트워크 통신 성공 -------------------"
        log.append("\n3️⃣[\(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("response: \n")
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("4️⃣\(reString)\n")
        }
        log.append("------------------- END HTTP -------------------")
        print(log)
    }
    
    func onFail(_ error: MoyaError) {
        var log = "------------------- 네트워크 오류"
        log.append("(에러코드: \(error.errorCode)) -------------------\n")
        log.append("3️⃣ \(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("------------------- END HTTP -------------------")
        print(log)
        
        let alertViewController = UIAlertController(title: "네트워크 연결 실패", message: "네트워크 환경을 한번 더 확인해주세요.", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))

        viewController.present(alertViewController, animated: true)
    }
}
