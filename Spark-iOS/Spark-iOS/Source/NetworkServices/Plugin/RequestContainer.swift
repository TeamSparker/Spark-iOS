//
//  RequestContainer.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/10/05.
//

import Foundation

import Moya

class RequestContainer {
    static let shared = RequestContainer()
    
    private var requestArray: [Cancellable] = []
    
    private init() { }
    
    public func doCleanRequest(request: Cancellable) {
        requestArray.forEach { $0.cancel() }
        requestArray.removeAll()
        requestArray.append(request)
    }
}

extension Cancellable {
    func doCleanRequest() {
        RequestContainer.shared.doCleanRequest(request: self)
    }
}
