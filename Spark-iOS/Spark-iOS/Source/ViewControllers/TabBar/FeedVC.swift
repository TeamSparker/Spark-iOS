//
//  FeedVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

class FeedVC: UIViewController {
    
    // MARK: - Dummy Data
    
    var dummyDataList: Array = [
        ["date": "2021-01-07", "day": "월요일", "userId": "1","recordId": "1", "nickname": "맥북1", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true,"totalFeedNum ": 20, "like": false, "roomName": "방1"],
        ["date": "2021-01-07", "day": "월요일", "userId": "1","recordId": "1","nickname": "맥북2", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true,"totalFeedNum ": 20, "like": false, "roomName": "방2"],
        ["date": "2021-01-07", "day": "월요일", "userId": "1","recordId": "1","nickname": "맥북3", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true,"totalFeedNum ": 20, "like": false, "roomName": "방3"],
        ["date": "2021-01-06", "day": "일요일", "userId": "1","recordId": "1","nickname": "맥북3", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true,"totalFeedNum ": 20, "like": false, "roomName": "방4"],
        ["date": "2021-01-06", "day": "일요일", "userId": "1","recordId": "1","nickname": "맥북4", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방5"],
        ["date": "2021-01-06", "day": "일요일", "userId": "1", "recordId": "1","nickname": "맥북5", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방6"],
        ["date": "2021-01-06", "day": "일요일", "userId": "1", "recordId": "1","nickname": "맥북6", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방7"],
        ["date": "2021-01-05", "day": "토요일", "userId": "1", "recordId": "1","nickname": "맥북7", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방8"],
        ["date": "2021-01-05", "day": "토요일", "userId": "1", "recordId": "1","nickname": "맥북8", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방9"]
    ]
    
    var newDummyDataList: Array = [
        ["date": "2021-01-05", "day": "토요일", "userId": "1","recordId": "1", "nickname": "그램", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true,"totalFeedNum ": 20, "like": false, "roomName": "방0"],
        ["date": "2021-01-04", "day": "금요일", "userId": "1","recordId": "1","nickname": "맥북2", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true,"totalFeedNum ": 20, "like": false, "roomName": "방0"],
        ["date": "2021-01-03", "day": "목요일", "userId": "1","recordId": "1","nickname": "맥북3", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true,"totalFeedNum ": 20, "like": false, "roomName": "방0"],
        ["date": "2021-01-03", "day": "목요일", "userId": "1","recordId": "1","nickname": "맥북3", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true,"totalFeedNum ": 20, "like": false, "roomName": "방0"],
        ["date": "2021-01-03", "day": "목요일", "userId": "1","recordId": "1","nickname": "맥북4", "profileImage": "~~","certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방7"],
        ["date": "2021-01-02", "day": "수요일", "userId": "1", "recordId": "1","nickname": "맥북5", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방7"],
        ["date": "2021-01-02", "day": "수요일", "userId": "1", "recordId": "1","nickname": "맥북6", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방7"],
        ["date": "2021-01-02", "day": "수요일", "userId": "1", "recordId": "1","nickname": "맥북7", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방10"],
        ["date": "2021-01-01", "day": "화요일", "userId": "1", "recordId": "1","nickname": "맥북8", "profileImage": "~~", "certifyingImg": "~~~", "sparkCount": 3, "isDone": true, "totalFeedNum ": 20, "like": false, "roomName": "방10"]
    ]
    
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
    private var isInfiniteScroll = true
    
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 맨 처음 빌드할 때 원래 FeedVC가 불려지는 것인가?
        setLayout()
        setCollectionView()
        setData(datalist: dummyDataList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
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
    
    func setData(datalist: Array<Dictionary<String, Any>>) {
        var indexPath = 0
        var sectionCount = 0 /// section을 돌기 위한 변수
        
        while indexPath < datalist.count {
            if dateList.isEmpty {
                dateList.append(datalist[indexPath]["date"] as! String)
                dayList.append(datalist[indexPath]["day"] as! String)
                indexPath += 1
            } else {
                let date: String = datalist[indexPath]["date"] as! String
                let day: String = datalist[indexPath]["day"] as! String

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

                if dateList[sectionCount] == datalist[indexinsection]["date"] as! String {
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

extension FeedVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dateList.count
    }
    
    // FIXME: - 서버 연결 후 수정
    // 무한 스크롤 방법 1
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.height {
//            if isInfiniteScroll {
//                print("??", isInfiniteScroll)
//                page += 1
//                isInfiniteScroll = false
//                // TODO: - 서버 데이터 추가로 받아오면서 isInfiniteScroll true 처리
//                dummyDataList.append(contentsOf: newDummyDataList)
//                setData(datalist: newDummyDataList)
//                collectionView.reloadData()
//            } else {
//                print("끝")
//            }
//        }
//    }
    
    // 무한 스크롤 방법 2
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            if page < 1 {
                dummyDataList.append(contentsOf: newDummyDataList)
                setData(datalist: newDummyDataList)
                collectionView.reloadData()
                page += 1
            } else {
                print("끝입니다")
            }
        }
    }
}

extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        var indexPath = 0
        
        while indexPath < dummyDataList.count {
            if dateList[section] == dummyDataList[indexPath]["date"] as! String {
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
        
        var alist: [String:Any] = [:]

        // section별 데이터 넣기
        switch indexPath.section {
        case 0:
            alist = firstList[indexPath.item] as! [String:Any]
        case 1:
            alist = secondList[indexPath.item] as! [String : Any]
        case 2:
            alist = thirdList[indexPath.item] as! [String:Any]
        case 3:
            alist = fourthList[indexPath.item] as! [String:Any]
        case 4:
            alist = fifthList[indexPath.item] as! [String:Any]
        case 5:
            alist = sixthList[indexPath.item] as! [String:Any]
        case 6:
            alist = seventhList[indexPath.item] as! [String:Any]
        default:
            alist = firstList[indexPath.item] as! [String:Any]
        }
        
//        print("alist: ", alist)

        if let roomname = alist["roomName"], let name = alist["nickname"],
            let sparkcount = alist["sparkCount"], let heartcount = alist["totalFeedNum"] {
            cell.titleLabel.text = "\(roomname)"
            cell.nameLabel.text = "\(name)"
            cell.sparkCountLabel.text = "\(sparkcount)"
            cell.heartCountLabel.text = "\(heartcount)"
        }
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FeedHeaderView", for: indexPath) as? FeedHeaderView else { return UICollectionReusableView() }
        
        let date = dateList[indexPath.section].split(separator: "-").map {
            Int($0) ?? 0
        }
        header.dateLabel.text = "\(String(date[0]))년 \(String(date[1]))월 \(String(date[2]))일"
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
