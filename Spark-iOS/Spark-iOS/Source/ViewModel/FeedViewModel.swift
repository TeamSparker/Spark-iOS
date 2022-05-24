//
//  FeedViewModel.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/05/19.
//

import Foundation

final class FeedViewModel {
    
    static let shared: FeedViewModel = FeedViewModel()
    public var dateList: [String] = []
    public var dayList: [String] = []
    public lazy var firstList: [Record] = []
    public lazy var secondList: [Record] = []
    public lazy var thirdList: [Record] = []
    public lazy var fourthList: [Record] = []
    public lazy var fifthList: [Record] = []
    public lazy var sixthList: [Record] = []
    public lazy var seventhList: [Record] = []
    public lazy var eighthList: [Record] = []
    
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
    
    func setDataList(sectionCount: Int, indexInSection: Int, datalist: [Record]) {
        switch sectionCount {
        case 0:
            firstList.append(datalist[indexInSection])
        case 1:
            secondList.append(datalist[indexInSection])
        case 2:
            thirdList.append(datalist[indexInSection])
        case 3:
            fourthList.append(datalist[indexInSection])
        case 4:
            fifthList.append(datalist[indexInSection])
        case 5:
            sixthList.append(datalist[indexInSection])
        case 6:
            seventhList.append(datalist[indexInSection])
        default:
            eighthList.append(datalist[indexInSection])
        }
    }
    
    func setHeaderDataList(date: String, day: String) {
        if dateList.isEmpty {
            dateList.append(date)
            dayList.append(day)
        } else {
            if !(dateList.contains(date)) {
                dateList.append(date)
                dayList.append(day)
            }
        }
    }
    
    /// cell 데이터 구성할 리스트 리턴하는 함수 - cellForItemAt
    func getDataList(indexPath: IndexPath) -> Record {
        var dataList: Record
        
        switch indexPath.section {
        case 0:
            print("✈️ firstList - \(firstList[indexPath.item])")
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
    
    func setFeedsList(isScroll: Bool) {
        if isScroll {
            self.feeds.append(contentsOf: self.newFeeds)
        } else {
            self.feeds = self.newFeeds
        }
        
        if feeds.count >= feedCountSize {
            isFirstScroll = false
        }
    }
    
    func setNewFeedsList(newList: Feed) {
        if newList.records.isEmpty {
            self.isLastScroll = true
        } else {
            self.isLastScroll = false
        }
        newFeeds = newList.records
    }
    
    /// 좋아요 상태에 따라 리스트의 isLike 및 likeNum 값 변경해주는 함수 - likeButtonTapped
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
        
        switch indexPath.section {
        case 0:
            firstList = targetList
        case 1:
            secondList = targetList
        case 2:
            thirdList = targetList
        case 3:
            fourthList = targetList
        case 4:
            fifthList = targetList
        case 5:
            sixthList = targetList
        case 6:
            seventhList = targetList
        default:
            eighthList = targetList
        }
    }
}
