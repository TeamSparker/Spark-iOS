//
//  RequestContainer.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/10/05.
//

import Foundation

import Moya

typealias APIType = RequestContainer.CancellableAPIType

class RequestContainer {
    
    static let shared = RequestContainer()
    
    enum CancellableAPIType: CaseIterable {
        case notice
        case home
        case storage
        case feed
    }
    
    private var requestDictionary: [CancellableAPIType: [Cancellable]] = [:]
    
    private init() {
        CancellableAPIType.allCases.forEach {
            requestDictionary[$0] = [] as [Cancellable]
        }
    }
    
    public func doCleanRequest(request: Cancellable, key: APIType) {
        requestDictionary[key]?.forEach { $0.cancel() }
        requestDictionary[key]?.removeAll()
        requestDictionary[key]?.append(request)
    }
}

extension Cancellable {
    func doCleanRequest(from apiType: APIType) {
        RequestContainer.shared.doCleanRequest(request: self, key: apiType)
    }
}
