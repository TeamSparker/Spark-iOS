//
//  MoyaLoggerPlugin.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/15.
//

import Foundation
import Moya

final class MoyaLoggerPlugin: PluginType {
    
  // Request를 보낼 때 호출
  func willSend(_ request: RequestType, target: TargetType) {
    guard let httpRequest = request.request else {
      print("--> 유효하지 않은 요청")
      return
    }
    let url = httpRequest.description
    let method = httpRequest.httpMethod ?? "unknown method"
    var log = "----------------------------------------------------\n[✅\(method)] \(url)\n----------------------------------------------------\n"
    log.append("API: \(target)\n")
    if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
      log.append("header: \(headers)\n")
    }
    if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
      log.append("\(bodyString)\n")
    }
    log.append("------------------- END \(method) --------------------------")
    print(log)
  }
    
  // Response가 왔을 때
  func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    switch result {
    case let .success(response):
      onSuceed(response, target: target)
    case let .failure(error):
      onFail(error, target: target)
    }
  }
    
  func onSuceed(_ response: Response, target: TargetType) {
    let request = response.request
    let url = request?.url?.absoluteString ?? "nil"
    let statusCode = response.statusCode
    var log = "------------------- 네트워크 통신 성공 -------------------"
    log.append("\n[✅\(statusCode)] \(url)\n----------------------------------------------------\n")
    log.append("API: \(target)\n")
//    response.response?.allHeaderFields.forEach {
//      log.append("\($0): \($1)\n")
//    }
    if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
      log.append("\(reString)\n")
    }
    log.append("------------------- END HTTP -------------------")
    print(log)
  }
    
  func onFail(_ error: MoyaError, target: TargetType) {
    if let response = error.response {
      onSuceed(response, target: target)
      return
    }
    var log = "네트워크 오류"
    log.append("<-- \(error.errorCode) \(target)\n")
    log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
    log.append("<-- END HTTP")
    print(log)
  }
}

