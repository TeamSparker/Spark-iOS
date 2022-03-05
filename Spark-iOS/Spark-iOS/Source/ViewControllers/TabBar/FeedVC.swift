//
//  FeedVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

import Lottie
import SnapKit

class FeedVC: UIViewController {
    
    // MARK: - Properties
    
    private let collectionViewFlowlayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowlayout)
    private lazy var loadingBgView = UIView()
    private lazy var loadingView = AnimationView(name: Const.Lottie.Name.loading)
    private lazy var refreshControl = UIRefreshControl()
    
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
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setCollectionView()
        initRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
        
        // FIXME: - 처음 피드 접속시 잘못된 lastID 에러 발생
        feedLastID = -1
        
        dateList.removeAll()
        dayList.removeAll()
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
    
    private func stopLoadingAnimation() {
        if loadingView.isAnimationPlaying {
            loadingView.stop()
            loadingBgView.removeFromSuperview()
        }
    }
    
    private func initRefreshControl() {
        refreshControl.tintColor = .sparkPinkred
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func refreshCollectionView() {
        feedLastID = -1
        
        dateList.removeAll()
        dayList.removeAll()
        feedList.removeAll()
        
        firstList.removeAll()
        secondList.removeAll()
        thirdList.removeAll()
        fourthList.removeAll()
        fifthList.removeAll()
        sixthList.removeAll()
        seventhList.removeAll()
        
        DispatchQueue.main.async {
            self.getFeedListFetchWithAPI(lastID: self.feedLastID) {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - Layout
extension FeedVC {
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
                    self.stopLoadingAnimation()
                    // 통신했을때 들어오는 records가 없으면 마지막 스크롤이므로 isLastScroll = true
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
                print("🤍 lastId: \(lastID)")
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
        // FIXME: - MainTBC에서 FeedVC를 네비게이션 컨트롤러로 만든 뒤부터 처음 뷰를 로드했을 때  scrollViewDidScroll 이 실행됨
        if collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.height {
            // isInfinitiScroll이 true이고, isLastScroll이 false일때 스크롤했을 경우만 feed 통신하도록
            if isInfiniteScroll && !isLastScroll {
                isInfiniteScroll = false
                isLastScroll = true
                
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
            
            cell.initCell(title: alist.roomName, nickName: alist.nickname, timeRecord: alist.timerRecord, likeCount: alist.likeNum, sparkCount: alist.sparkCount, profileImg: alist.profileImg, certifyingImg: alist.certifyingImg, hasTime: true, isLiked: alist.isLiked, recordId: alist.recordID, indexPath: indexPath)
            cell.buttonDelegate = self
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
                
                // 마지막 스크롤이면 loading 멈추고, 마지막이 아닌 경우 loading
                if isLastScroll && isInfiniteScroll {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if dateList.count != 0 {
            // isInfiniteScroll이며 마지막 section일 경우에만 footer가 보이도록 한다.
            // scroll될 때는 loading이 있는 footer를 보이며, 마지막 section만 멘트가 표시된 footer가 남아있다.
            if isInfiniteScroll && section == collectionView.numberOfSections-1 {
                let width = UIScreen.main.bounds.width
                let height = width*120/375
                return CGSize(width: width, height: height)
            } else {
                return .zero
            }
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
    func moreButtonTapped(recordID: Int, indexPath: IndexPath) {
        print("🍎 recordID: \(recordID), indexPath: \(indexPath)")
        let alert = SparkActionSheet()
        alert.addAction(SparkAction("신고하기", titleType: .blackMediumTitle, handler: {
            alert.dismiss(animated: true) {
                guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.feedReport, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.feedReport) as? FeedReportVC else { return }
//                self.navigationController?.pushViewController(nextVC, animated: true)
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil)
            }
        }))
        
        alert.addSection()
        alert.addAction(SparkAction("취소", titleType: .blackBoldTitle, handler: {
            self.dismiss(animated: true) {
                // FIXME: - MaicTabbar가 feedVC를 포함하고 있어서 feedVC에서 액션 시트를 띄울 경우 탭바 아래로 띄워짐
                // 임시로 탭바를 hidden 시키고 있는 상황
                self.tabBarController?.tabBar.isHidden = false
            }
        }))
        
        tabBarController?.tabBar.isHidden = true
        
        present(alert, animated: true)
    }
    
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
