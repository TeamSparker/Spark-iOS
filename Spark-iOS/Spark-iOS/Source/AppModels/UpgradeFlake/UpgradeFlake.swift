//
//  UpgradeFlake.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/10/08.
//

import UIKit

public struct UpgradeFlake {
    let flakeImage: UIImage
    let upgradeText: String
    let levelTest: String
    
    init(_ flakeImage: UIImage, _ upgradeText: String, _ levelTest: String) {
        self.flakeImage = flakeImage
        self.upgradeText = upgradeText
        self.levelTest = levelTest
    }
}
