//
//  FeedVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

class FeedVC: UIViewController {
    
    // MARK: - Properties
    
    let collectionViewFlowlayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowlayout)
    
    private var dateList: [String] = []
    private var dayList: [String] = []
    private var firstList: [Record] = []
    private var secondList: [Record] = []
    private var thirdList: [Record] = []
    private var fourthList: [Record] = []
    private var fifthList: [Record] = []
    private var sixthList: [Record] = []
    private var seventhList: [Record] = []
    
    private var feedList: [Record] = []
    private var feedLastID: Int = -1
    private var feedCountSize: Int = 7
    private var isInfiniteScroll = true
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setCollectionView()
        
        // FIXME: - getFeedListFetchWithAPI 위치 변경
        DispatchQueue.main.async {
            self.getFeedListFetchWithAPI(lastID: self.feedLastID) {
//                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: false)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
        tabBarController?.tabBar.isHidden = false
        // FIXME: - getFeedListFetchWithAPI를 여기서 호출하는거로 변경
//        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: false)
    }
    
    // MARK: - Methods
    
    func setCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FeedHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedHeaderView.identifier)
        collectionView.register(FeedCVC.self, forCellWithReuseIdentifier: FeedCVC.identifier)
        collectionView.register(FeedEmptyCVC.self, forCellWithReuseIdentifier: FeedEmptyCVC.identifier)
        
        collectionViewFlowlayout.scrollDirection = .vertical
        collectionViewFlowlayout.sectionHeadersPinToVisibleBounds = true
    }
    
    func setData(datalist: [Record]) {
        var indexPath = 0
        var sectionCount = 0 // section을 돌기 위한 변수
        
        // 섹션에 들어갈 날짜 리스트 구함
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
        var indexInSection = 0
        while indexInSection < datalist.count && !datalist.isEmpty && sectionCount < dateList.count {
            if dateList[sectionCount] == datalist[indexInSection].date {
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
                    seventhList.append(datalist[indexInSection])
                }
                indexInSection += 1
            } else {
                sectionCount += 1
            }
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
    private func getFeedListFetchWithAPI(lastID: Int, completion: @escaping() -> Void) {
        FeedAPI.shared.feedFetch(lastID: lastID, size: feedCountSize) { response in
            
            switch response {
            case .success(let data):
                if let feed = data as? Feed {
                    self.feedList.append(contentsOf: feed.records)
                    self.setData(datalist: feed.records)
                    self.collectionView.reloadData()
                }
                completion()
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
    
    func postFeedLikeWithAPI(recordID: Int) {
        FeedAPI.shared.feedLike(recordID: recordID) { response in
            switch response {
            case .success(let message):
                print("feedLikeWithAPI - success: \(message)")
            case .requestErr(let message):
                print("feedLikeWithAPI - requestErr: \(message)")
            case .pathErr:
                print("feedLikeWithAPI - pathErr")
            case .serverErr:
                print("feedLikeWithAPI - serverErr")
            case .networkFail:
                print("feedLikeWithAPI - networkFail")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FeedVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dateList.count == 0 ? 1: dateList.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.height {
            if isInfiniteScroll {
                isInfiniteScroll = false
                
                feedLastID = feedList.last?.recordID ?? 0
                getFeedListFetchWithAPI(lastID: feedLastID) {
                    self.isInfiniteScroll = true
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dateList.count != 0 {
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
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dateList.count != 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCVC.identifier, for: indexPath) as? FeedCVC else { return UICollectionViewCell() }
            
            var alist: Record
            
            // section별 데이터 넣기
            switch indexPath.section {
            case 0:
                alist = firstList[indexPath.item]
            case 1:
                alist = secondList[indexPath.item]
            case 2:
                alist = thirdList[indexPath.item]
            case 3:
                alist = fourthList[indexPath.item]
            case 4:
                alist = fifthList[indexPath.item]
            case 5:
                alist = sixthList[indexPath.item]
            case 6:
                alist = seventhList[indexPath.item]
            default:
                alist = firstList[indexPath.item]
            }
            
            cell.initCell(title: alist.roomName, nickName: alist.nickname, timeRecord: alist.timerRecord, likeCount: alist.likeNum, sparkCount: alist.sparkCount, profileImg: alist.profileImg, certifyingImg: alist.certifyingImg ?? "", hasTime: true, isLiked: alist.isLiked, recordId: alist.recordID)
            cell.likeDelegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedEmptyCVC.identifier, for: indexPath) as? FeedEmptyCVC else { return UICollectionViewCell() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if dateList.count != 0 {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FeedHeaderView", for: indexPath) as? FeedHeaderView else { return UICollectionReusableView() }
            
            let date = dateList[indexPath.section].split(separator: "-")
            header.dateLabel.text = "\(date[0])년 \(date[1])월 \(date[2])일"
            header.dayLabel.text = "\(dayList[indexPath.section])"
            
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if dateList.count != 0 {
            let width = UIScreen.main.bounds.width
            let height = width*85/375
            
            return CGSize(width: width, height: height)
        } else {
            return .zero
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat
        var height: CGFloat
        
        if dateList.count != 0 {
            width = UIScreen.main.bounds.width
            height = width*535/375
        } else {
            width = UIScreen.main.bounds.width
            height = self.collectionView.frame.height
        }
        return CGSize(width: width, height: height)
    }
}

// MARK: - Protocol
extension FeedVC: FeedCellDelegate {
    func likeButtonTapped(recordID: Int) {
        postFeedLikeWithAPI(recordID: recordID)
    }
}
