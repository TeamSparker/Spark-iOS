//
//  FeedVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

import Lottie

class FeedVC: UIViewController {
    
    // MARK: - Properties
    
    let collectionViewFlowlayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowlayout)
    
    lazy var loadingBgView = UIView()
    lazy var loadingView = AnimationView(name: Const.Lottie.Name.loading)
    
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
    private var isLastScroll = false
    private var footerIndex = 0
    private lazy var totalList = [firstList, secondList, thirdList, fourthList, fifthList, sixthList, seventhList]
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
        tabBarController?.tabBar.isHidden = false
        
        feedLastID = -1
        
        feedList.removeAll()
        firstList.removeAll()
        secondList.removeAll()
        thirdList.removeAll()
        fourthList.removeAll()
        fifthList.removeAll()
        sixthList.removeAll()
        seventhList.removeAll()
        
        DispatchQueue.main.async {
            self.setLoading()
        }
        
        DispatchQueue.main.async {
            self.getFeedListFetchWithAPI(lastID: self.feedLastID) {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: false)
                self.isLastScroll = false
            }
        }
    }
    
    // MARK: - Methods
    
    private func setLoading() {
        view.addSubview(loadingBgView)
        
        loadingBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingBgView.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
        }
        
        loadingBgView.backgroundColor = .white
        loadingView.loopMode = .loop
        loadingView.contentMode = .scaleAspectFit
        loadingView.play()
    }
    
    private func setCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FeedHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Cell.Identifier.feedHeaderView)
        collectionView.register(FeedFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Const.Cell.Identifier.feedFooterView)
        collectionView.register(FeedCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.feedCVC)
        collectionView.register(FeedEmptyCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.feedEmptyCVC)
        
        collectionViewFlowlayout.scrollDirection = .vertical
        collectionViewFlowlayout.sectionHeadersPinToVisibleBounds = true
    }
    
    private func setData(datalist: [Record]) {
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
    
    private func setLayout() {
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
                    self.loadingView.stop()
                    self.loadingBgView.removeFromSuperview()
                    
                    if feed.records.isEmpty {
                        self.isLastScroll = true
                    } else {
                        self.isLastScroll = false
                    }
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
    
    private func postFeedLikeWithAPI(recordID: Int) {
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
            if isInfiniteScroll && !isLastScroll {
                isInfiniteScroll = false
                isLastScroll = true
                
                feedLastID = feedList.last?.recordID ?? 0
                getFeedListFetchWithAPI(lastID: feedLastID) {
                    self.isInfiniteScroll = true
                    while self.footerIndex < 7 {
                        if self.totalList[self.footerIndex].count == 0 {
                            self.footerIndex += 1
                            break
                        } else {
                            self.footerIndex += 1
                        }
                    }
                    print("⚡️ footerIndex: \(self.footerIndex)")
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.feedCVC, for: indexPath) as? FeedCVC else { return UICollectionViewCell() }
            
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
            
            cell.initCell(title: alist.roomName, nickName: alist.nickname, timeRecord: alist.timerRecord, likeCount: alist.likeNum, sparkCount: alist.sparkCount, profileImg: alist.profileImg, certifyingImg: alist.certifyingImg ?? "", hasTime: true, isLiked: alist.isLiked, recordId: alist.recordID, indexPath: indexPath)
            cell.likeDelegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.feedEmptyCVC, for: indexPath) as? FeedEmptyCVC else { return UICollectionViewCell() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if dateList.count != 0 {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Cell.Identifier.feedHeaderView, for: indexPath) as? FeedHeaderView else { return UICollectionReusableView() }
                
                let date = dateList[indexPath.section].split(separator: "-")
                header.dateLabel.text = "\(date[0])년 \(date[1])월 \(date[2])일"
                header.dayLabel.text = "\(dayList[indexPath.section])"
                
                return header
                
            case UICollectionView.elementKindSectionFooter:
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Const.Cell.Identifier.feedFooterView, for: indexPath) as? FeedFooterView else { return UICollectionReusableView() }
                // TODO: - 리스트 끝에서 footer가 보임
                if isLastScroll {
                    footer.stopLoading()
                } else {
                    footer.playLoading()
                }
                return footer
            default:
                return UICollectionReusableView()
            }
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
    
    // TODO: - loading 중이면 로티, 아니면 라벨 보이기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if dateList.count != 0 {
            // 맨 마지막 리스트를 찾아서 걔에만 CGSize 리턴
//            print("🥕index: \(index), section: \(section)")
//            if section == index-1 {
//                let width = UIScreen.main.bounds.width
//                let height = width*120/375
//                return CGSize(width: width, height: height)
//            } else {
//                return .zero
//            }
//            switch section {
//            case 6:
//                let width = UIScreen.main.bounds.width
//                let height = width*120/375
//                return CGSize(width: width, height: height)
//            default:
//                return .zero
//            }
            print("1️⃣ isInfiniteScroll:\(isInfiniteScroll), isLastScroll: \(isLastScroll), section: \(section), collectionView.numberOfSections: \(collectionView.numberOfSections)")
            if isInfiniteScroll && section == collectionView.numberOfSections-1 {
                let width = UIScreen.main.bounds.width
                let height = width*120/375
                return CGSize(width: width, height: height)
            } else {
                return .zero
            }
            
            // firstList, secondList 등등에 데이터가 있으면 하고 없으면 zero
//            if totalList[section].count == 0 {
//                let width = UIScreen.main.bounds.width
//                let height = width*120/375
//                print("🏅 list: \(totalList[section])")
//                return CGSize(width: width, height: height)
//            } else {
//                return .zero
//            }
//            let width = UIScreen.main.bounds.width
//            let height = width*120/375
//            return CGSize(width: width, height: height)
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
    func likeButtonTapped(recordID: Int, indexPath: IndexPath, likeState: Bool) {
        if indexPath.section == 0 {
            if likeState {
                firstList[indexPath.item].isLiked = false
                firstList[indexPath.item].likeNum -= 1
            } else {
                firstList[indexPath.item].isLiked = true
                firstList[indexPath.item].likeNum += 1
            }
        } else if indexPath.section == 1 {
            if likeState {
                secondList[indexPath.item].isLiked = false
                secondList[indexPath.item].likeNum -= 1
            } else {
                secondList[indexPath.item].isLiked = true
                secondList[indexPath.item].likeNum += 1
            }
        } else if indexPath.section == 2 {
            if likeState {
                thirdList[indexPath.item].isLiked = false
                thirdList[indexPath.item].likeNum -= 1
            } else {
                thirdList[indexPath.item].isLiked = true
                thirdList[indexPath.item].likeNum += 1
            }
        } else if indexPath.section == 3 {
            if likeState {
                fourthList[indexPath.item].isLiked = false
                fourthList[indexPath.item].likeNum -= 1
            } else {
                fourthList[indexPath.item].isLiked = true
                fourthList[indexPath.item].likeNum += 1
            }
        } else if indexPath.section == 4 {
            if likeState {
                fifthList[indexPath.item].isLiked = false
                fifthList[indexPath.item].likeNum -= 1
            } else {
                fifthList[indexPath.item].isLiked = true
                fifthList[indexPath.item].likeNum += 1
            }
        } else if indexPath.section == 5 {
            if likeState {
                sixthList[indexPath.item].isLiked = false
                sixthList[indexPath.item].likeNum -= 1
            } else {
                sixthList[indexPath.item].isLiked = true
                sixthList[indexPath.item].likeNum += 1
            }
        } else if indexPath.section == 6 {
            if likeState {
                seventhList[indexPath.item].isLiked = false
                seventhList[indexPath.item].likeNum -= 1
            } else {
                seventhList[indexPath.item].isLiked = true
                seventhList[indexPath.item].likeNum += 1
            }
        }
         
        postFeedLikeWithAPI(recordID: recordID)
    }
}
