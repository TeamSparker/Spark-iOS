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
    let levelText: String
    
    init(_ flakeImage: UIImage, _ upgradeText: String, _ levelText: String) {
        self.flakeImage = flakeImage
        self.upgradeText = upgradeText
        self.levelText = levelText
    }
}
