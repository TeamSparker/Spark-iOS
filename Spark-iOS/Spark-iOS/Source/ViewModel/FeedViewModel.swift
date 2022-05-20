//
//  FeedViewModel.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/05/19.
//

import UIKit


final class FeedViewModel {
    
    static let shared: FeedViewModel = FeedViewModel()
    // public private(set) - 외부에서는 읽기만 가능하고 내부에서는 수정도 가능한 상태
    public var dateList: [String] = []
    public var dayList: [String] = []
    public var firstList: [Record] = []
    public var secondList: [Record] = []
    public var thirdList: [Record] = []
    public var fourthList: [Record] = []
    public var fifthList: [Record] = []
    public var sixthList: [Record] = []
    public var seventhList: [Record] = []
    public var eighthList: [Record] = []
    
    public var newFeeds: [Record] = []
    public var feeds: [Record] = []
    public var isInfiniteScroll = true
    public var isLastScroll = false
    public var isFirstScroll = true
    public private(set) var feedInitID: Int = -1
    public private(set) var feedCountSize: Int = 7
    
    // MARK: - Custom Method
    
    func removeAllData() {
        dateList.removeAll()
        dayList.removeAll()
        firstList.removeAll()
        secondList.removeAll()
        thirdList.removeAll()
        fourthList.removeAll()
        fifthList.removeAll()
        sixthList.removeAll()
        seventhList.removeAll()
        eighthList.removeAll()
    }
    
    func setDataList(indexPath: IndexPath) -> Record {
        var dataList: Record
        
        switch indexPath.section {
        case 0:
            dataList = firstList[indexPath.item]
        case 1:
            dataList = secondList[indexPath.item]
        case 2:
            dataList = thirdList[indexPath.item]
        case 3:
            dataList = fourthList[indexPath.item]
        case 4:
            dataList = fifthList[indexPath.item]
        case 5:
            dataList = sixthList[indexPath.item]
        case 6:
            dataList = seventhList[indexPath.item]
        default:
            dataList = eighthList[indexPath.item]
        }
        
        return dataList
    }
    
    func changeLikeState(indexPath: IndexPath, likeState: Bool) {
        var targetList: [Record]
        
        switch indexPath.section {
        case 0:
            targetList = firstList
        case 1:
            targetList = secondList
        case 2:
            targetList = thirdList
        case 3:
            targetList = fourthList
        case 4:
            targetList = fifthList
        case 5:
            targetList = sixthList
        case 6:
            targetList = seventhList
        default:
            targetList = eighthList
        }
        
        if likeState {
            targetList[indexPath.item].isLiked = false
            targetList[indexPath.item].likeNum -= 1
        } else {
            targetList[indexPath.item].isLiked = true
            targetList[indexPath.item].likeNum += 1
        }
    }
}
