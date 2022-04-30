//
//  SendSparkCellDelegate.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/03/12.
//

import Foundation

protocol SendSparkCellDelegate: AnyObject {
    func sendSpark(with content: String, type: SendSparkStatus?)
    func showTextField()
}
