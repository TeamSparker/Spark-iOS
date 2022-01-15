//
//  Stopwatch.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/16.
//

import Foundation

class Stopwatch: NSObject {
    var counter: Double
    var timer: Timer
    
    override init() {
        counter = 0.0
        timer = Timer()
    }
}
