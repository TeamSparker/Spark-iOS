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
    public var contentList = Array(repeating: [Record](), count: 8)
    
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
        for i in 0...7 {
            contentList[i].removeAll()
        }
    }
    
    func setDataList(sectionCount: Int, indexInSection: Int, datalist: [Record]) {
        contentList[sectionCount].append(datalist[indexInSection])
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
        dataList = contentList[indexPath.section][indexPath.item]
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
        targetList = contentList[indexPath.section]
        
        if likeState {
            targetList[indexPath.item].isLiked = false
            targetList[indexPath.item].likeNum -= 1
        } else {
            targetList[indexPath.item].isLiked = true
            targetList[indexPath.item].likeNum += 1
        }
        
        contentList[indexPath.section] = targetList
    }
}
