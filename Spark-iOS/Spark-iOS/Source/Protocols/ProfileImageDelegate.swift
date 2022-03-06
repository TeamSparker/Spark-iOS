//
//  ProfileImageDelegate.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/06.
//

import Foundation
import UIKit

protocol ProfileImageDelegate: AnyObject {
    func sendProfile(image profileImage: UIImage, nickname: String)
}
