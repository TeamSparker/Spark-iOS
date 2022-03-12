//
//  OnboardingCVCViewModel.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/03/12.
//

import Foundation
import UIKit

struct OnboardingCVCViewModel {
    private let indexPath: IndexPath
    
    var mainImage: UIImage? {
        return UIImage()
    }
    
    var guideText: String {
        return ""
    }
    
    var buttonStatus: Bool {
        return true
    }
    
    init(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}
