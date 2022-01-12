//
//  FeedVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

class FeedVC: UIViewController {
    
    // MARK: - Dummy Data
    
    /// 9
    /// 20210107(3) 20210106(4) 20210105(2)
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
    
    /// 20210105(1) 20210104(1) 20210103(3) 20210102(3) 20210101(1)
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
    
    var index = 0
    var dateList: [String] = [] /// dateList에는 그냥 2021-01-04 형태로 받음 -> cell에 넣으줄 때 변환
    var firstList: [Any] = []
    var secondList: [Any] = []
    var thirdList: [Any] = []
    var fourthList: [Any] = []
    var fifthList: [Any] = []
    var sixthList: [Any] = []
    var seventhList: [Any] = []
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 맨 처음 빌드할 때 바로? FeedVC가 불려지는 것인가?
        setLayout()
        setCollectionView()
        setData(datalist: dummyDataList)
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
        
//        print(dummyDataList[indexPath]["date"])
//        print(type(of: dummyDataList[indexPath]["date"]))
//        print(dummyDataList[indexPath])
        
//        print(datalist)
//        print(type(of: datalist))
//        print(dummyDataList)
//        print(type(of: dummyDataList))
        while indexPath < datalist.count {
            if dateList.isEmpty {
                dateList.append(datalist[indexPath]["date"] as! String)
                indexPath += 1
            } else {
                let day: String = datalist[indexPath]["date"] as! String

                if !(dateList.contains(day)) {
                    dateList.append(day)
                }

                indexPath += 1
            }
        }

        // TODO: - section별 리스트 생성
        while sectionCount < dateList.count {
            var index = 0
            while index < datalist.count && !datalist.isEmpty && sectionCount != dateList.count {

                if dateList[sectionCount] == datalist[index]["date"] as! String {
                    switch sectionCount {
                    case 0:
                        firstList.append(datalist[index])
                    case 1:
                        secondList.append(datalist[index])
                    case 2:
                        thirdList.append(datalist[index])
                    case 3:
                        fourthList.append(datalist[index])
                    case 4:
                        fifthList.append(datalist[index])
                    case 5:
                        sixthList.append(datalist[index])
                    case 6:
                        seventhList.append(datalist[index])
                    default:
                        seventhList.append(datalist[index])
                    }

                }
                index += 1
            }
            sectionCount += 1
        }
        
        print("1: ", firstList)
        print("2: ", secondList)
        print("2: ", thirdList)
        print("4: ", fourthList)
        print("5: ", fifthList)
        print("6: ", sixthList)
        print("7: ", seventhList)
        print("-------------------------------------------------------")
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
        return 7
    }
}

extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCVC.identifier, for: indexPath) as? FeedCVC else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FeedHeaderView", for: indexPath) as? FeedHeaderView else { return UICollectionReusableView() }
        
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
