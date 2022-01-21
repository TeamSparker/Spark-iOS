//
//  FeedCellDelegate.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/18.
//

import Foundation

protocol FeedCellDelegate: AnyObject {
    func likeButtonTapped(recordID: Int, indexPath: IndexPath, likeState: Bool)
}
