//
//  UIImageView+.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/17.
//

import Foundation
import UIKit

import Kingfisher

extension UIImageView {
    @discardableResult
    func updateImage(_ imagePath: String) -> Bool {
        guard let url = URL(string: imagePath) else {
            self.image = UIImage()
            return false
        }
        self.kf.indicatorType = .none
        self.kf.setImage(
            with: url,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                print("kingfisher work failed: \(error.localizedDescription)")
            }
        }
        return true
    }
}

