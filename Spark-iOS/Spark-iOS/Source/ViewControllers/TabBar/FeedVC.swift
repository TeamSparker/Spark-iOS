//
//  FeedVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

class FeedVC: UIViewController {
    
    // MARK: - Dummy Data
    
//    var dummyDataList: Array = [
//        ["date": "2021-01-07", "day": "월요일", "userId": "1", "recordId": "1", "nickname": "맥북1", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방1"],
//        ["date": "2021-01-07", "day": "월요일", "userId": "1", "recordId": "1", "nickname": "맥북2", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방2"],
//        ["date": "2021-01-07", "day": "월요일", "userId": "1", "recordId": "1", "nickname": "맥북3", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방3"],
//        ["date": "2021-01-06", "day": "일요일", "userId": "1", "recordId": "1", "nickname": "맥북3", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방4"],
//        ["date": "2021-01-06", "day": "일요일", "userId": "1", "recordId": "1", "nickname": "맥북4", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방5"],
//        ["date": "2021-01-06", "day": "일요일", "userId": "1", "recordId": "1", "nickname": "맥북5", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방6"],
//        ["date": "2021-01-06", "day": "일요일", "userId": "1", "recordId": "1", "nickname": "맥북6", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방7"],
//        ["date": "2021-01-05", "day": "토요일", "userId": "1", "recordId": "1", "nickname": "맥북7", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방8"],
//        ["date": "2021-01-05", "day": "토요일", "userId": "1", "recordId": "1", "nickname": "맥북8", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방9"]
//    ]
//
//    var newDummyDataList: Array = [
//        ["date": "2021-01-05", "day": "토요일", "userId": "1", "recordId": "1", "nickname": "그램", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방0"],
//        ["date": "2021-01-04", "day": "금요일", "userId": "1", "recordId": "1", "nickname": "맥북2", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방0"],
//        ["date": "2021-01-03", "day": "목요일", "userId": "1", "recordId": "1", "nickname": "맥북3", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방0"],
//        ["date": "2021-01-03", "day": "목요일", "userId": "1", "recordId": "1", "nickname": "맥북3", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방0"],
//        ["date": "2021-01-03", "day": "목요일", "userId": "1", "recordId": "1", "nickname": "맥북4", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방7"],
//        ["date": "2021-01-02", "day": "수요일", "userId": "1", "recordId": "1", "nickname": "맥북5", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방7"],
//        ["date": "2021-01-02", "day": "수요일", "userId": "1", "recordId": "1", "nickname": "맥북6", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방7"],
//        ["date": "2021-01-02", "day": "수요일", "userId": "1", "recordId": "1", "nickname": "맥북7", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방10"],
//        ["date": "2021-01-01", "day": "화요일", "userId": "1", "recordId": "1", "nickname": "맥북8", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방10"]
//    ]
    
    // MARK: - Properties
    
    let collectionViewFlowlayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowlayout)
    
    private var dateList: [String] = []
    private var dayList: [String] = []
    private var firstList: [Any] = []
    private var secondList: [Any] = []
    private var thirdList: [Any] = []
    private var fourthList: [Any] = []
    private var fifthList: [Any] = []
    private var sixthList: [Any] = []
    private var seventhList: [Any] = []
    private var page = 0
    private var feedList: [Record] = []
    private var feedLastID: Int = -1
    private var feedCountSize: Int = 3
    private var isInfiniteScroll = true
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
        
        DispatchQueue.main.async {
            self.feedLastID = -1
            self.feedList.removeAll()
        }
        
        DispatchQueue.main.async {
            self.feedListFetchWithAPI(lastID: self.feedLastID) {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
    // MARK: - Methods
    
    func setCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FeedHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedHeaderView.identifier)
        collectionView.register(FeedCVC.self, forCellWithReuseIdentifier: FeedCVC.identifier)
        
        collectionViewFlowlayout.scrollDirection = .vertical
        collectionViewFlowlayout.sectionHeadersPinToVisibleBounds = true
    }
    
    func setData(datalist: [Record]) {
        var indexPath = 0
        var sectionCount = 0 // section을 돌기 위한 변수
        
        while indexPath < datalist.count {
            if dateList.isEmpty {
                dateList.append(datalist[indexPath].date)
                dayList.append(datalist[indexPath].day)
                indexPath += 1
            } else {
                let date: String = datalist[indexPath].date
                let day: String = datalist[indexPath].day

                if !(dateList.contains(date)) {
                    dateList.append(date)
                    dayList.append(day)
                }

                indexPath += 1
            }
        }

        // section별 리스트 생성
        while sectionCount < dateList.count {
            var indexinsection = 0
            while indexinsection < datalist.count && !datalist.isEmpty && sectionCount != dateList.count {

                if dateList[sectionCount] == datalist[indexinsection].date {
                    switch sectionCount {
                    case 0:
                        firstList.append(datalist[indexinsection])
                    case 1:
                        secondList.append(datalist[indexinsection])
                    case 2:
                        thirdList.append(datalist[indexinsection])
                    case 3:
                        fourthList.append(datalist[indexinsection])
                    case 4:
                        fifthList.append(datalist[indexinsection])
                    case 5:
                        sixthList.append(datalist[indexinsection])
                    case 6:
                        seventhList.append(datalist[indexinsection])
                    default:
                        seventhList.append(datalist[indexinsection])
                    }

                }
                indexinsection += 1
            }
            sectionCount += 1
        }
    }
    
    func setLayout() {
        view.addSubviews([collectionView])
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Network

extension FeedVC {
    private func feedListFetchWithAPI(lastID: Int, completion: @escaping() -> Void) {
        FeedAPI.shared.feedFetch(lastID: lastID, size: feedCountSize) { response in
            
            switch response {
            case .success(let data):
                if let feed = data as? RecordList {
                    self.feedList.append(contentsOf: feed.records)
                    self.setData(datalist: self.feedList)
                }
                
                self.collectionView.reloadData()
                
            case .requestErr(let message):
                print("feedListFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("feedListFetchWithAPI - pathErr")
            case .serverErr:
                print("feedListFetchWithAPI - serverErr")
            case .networkFail:
                print("feedListFetchWithAPI - networkFail")
            }
        }
    }
}


// MARK: - UICollectionViewDelegate

extension FeedVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dateList.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.height {
            if isInfiniteScroll {
                isInfiniteScroll = false

                feedLastID = feedList.last?.recordID ?? 0
                feedListFetchWithAPI(lastID: feedLastID) {
                    self.isInfiniteScroll = true
                }
            }
        }
    }
}

extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        var indexPath = 0
        
        while indexPath < feedList.count {
            if dateList[section] == feedList[indexPath].date {
                itemCount += 1
                indexPath += 1
            } else {
                indexPath += 1
            }
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCVC.identifier, for: indexPath) as? FeedCVC else { return UICollectionViewCell() }
        var alist: Record

        // section별 데이터 넣기
        switch indexPath.section {
        case 0:
            alist = firstList[indexPath.item] as! Record
        case 1:
            alist = secondList[indexPath.item] as! Record
        case 2:
            alist = thirdList[indexPath.item] as! Record
        case 3:
            alist = fourthList[indexPath.item] as! Record
        case 4:
            alist = fifthList[indexPath.item] as! Record
        case 5:
            alist = sixthList[indexPath.item] as! Record
        case 6:
            alist = seventhList[indexPath.item] as! Record
        default:
            alist = firstList[indexPath.item] as! Record
        }
        
        cell.initCell(title: alist.roomName, nickName: alist.nickname, timeRecord: alist.timerRecord, likeCount: alist.likeNum, sparkCount: alist.sparkCount, profileImg: "profileEmpty", certifyingImg: "uploadEmptyView", hasTime: true)

        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FeedHeaderView", for: indexPath) as? FeedHeaderView else { return UICollectionReusableView() }
        
        let date = dateList[indexPath.section].split(separator: "-")
        header.dateLabel.text = "\(date[0])년 \(date[1])월 \(date[2])일"
        header.dayLabel.text = "\(dayList[indexPath.section])"
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = width*85/375
        
        return CGSize(width: width, height: height)
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = width*535/375
        
        return CGSize(width: width, height: height)
    }
}
