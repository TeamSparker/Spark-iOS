//
//  FeedVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

import Lottie
import SnapKit
import FirebaseAnalytics

class FeedVC: UIViewController {
    
    // MARK: - Properties
    
    private let emptyView = UIView()
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()
    
    private let viewModel = FeedViewModel.shared
    private let collectionViewFlowlayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowlayout)
    private lazy var loadingBgView = UIView()
    private lazy var loadingView = AnimationView(name: Const.Lottie.Name.loading)
    private lazy var refreshControl = UIRefreshControl()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHiddenCollectionView()
        setLayout()
        setCollectionView()
        setNotification()
        initRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
        setTabBar()
        setFloatingButton()
        setLoading()
        
        getFeedListFetchWithAPI(lastID: self.viewModel.feedInitID) {
            self.viewModel.feeds = self.viewModel.newFeeds
            if self.viewModel.feeds.count >= self.viewModel.feedCountSize {
                self.viewModel.isFirstScroll = false
            }
            self.viewModel.removeAllData()
            
            self.setData(datalist: self.viewModel.newFeeds)
            if !self.viewModel.feeds.isEmpty {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    // MARK: - Methods
    
    private func updateHiddenCollectionView() {
        emptyView.isHidden = true
        collectionView.isHidden = false
    }
    
    private func setTabBar() {
        guard let tabBarController = tabBarController as? SparkTabBarController else { return }
        tabBarController.sparkTabBar.isHidden = false
    }
    
    private func setFloatingButton() {
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
    }
    
    private func setEmptyView() {
        emptyView.isHidden = false
        collectionView.isHidden = true
        
        emptyLabel.text = "아직 올라온 인증이 없어요.\n습관방에서 첫 인증을 시작해 보세요!"
        emptyLabel.textAlignment = .center
        emptyLabel.font = .h3SubtitleLight
        emptyLabel.partFontChange(targetString: "아직 올라온 인증이 없어요.", font: .h3SubtitleBold)
        emptyLabel.textColor = .sparkGray
        emptyLabel.numberOfLines = 2
        emptyImageView.image = UIImage(named: "tagEmpty")
    }
    
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
        
        collectionViewFlowlayout.scrollDirection = .vertical
        collectionViewFlowlayout.sectionHeadersPinToVisibleBounds = true
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setToastMessage), name: .feedReport, object: nil)
    }
    
    // FIXME: - 불났다
    private func setData(datalist: [Record]) {
        // viewmodel에서 feeds.isEmpty의 bool 값을 리턴하도록 해서 그 안에서 엠티뷰 세팅 / 컬렉션뷰 보이기 만 조절하도록
        
        if viewModel.feeds.isEmpty {
            setEmptyView()
        } else {
            updateHiddenCollectionView()
            var indexPath = 0
            var sectionCount = 0 // section을 돌기 위한 변수
            
            // 섹션에 들어갈 날짜 리스트 구함

            while indexPath < datalist.count {
                let date: String = datalist[indexPath].date
                let day: String = datalist[indexPath].day
                
                viewModel.setHeaderDataList(date: date, day: day)
                indexPath += 1
            }
            
            // section별 리스트 생성
            var indexInSection = 0
            while indexInSection < datalist.count && !datalist.isEmpty && sectionCount < viewModel.dateList.count {
                if viewModel.dateList[sectionCount] == datalist[indexInSection].date {
                    switch sectionCount {
                    case 0:
                        viewModel.firstList.append(datalist[indexInSection])
                    case 1:
                        viewModel.secondList.append(datalist[indexInSection])
                    case 2:
                        viewModel.thirdList.append(datalist[indexInSection])
                    case 3:
                        viewModel.fourthList.append(datalist[indexInSection])
                    case 4:
                        viewModel.fifthList.append(datalist[indexInSection])
                    case 5:
                        viewModel.sixthList.append(datalist[indexInSection])
                    case 6:
                        viewModel.seventhList.append(datalist[indexInSection])
                    default:
                        viewModel.eighthList.append(datalist[indexInSection])
                    }
                    indexInSection += 1
                } else {
                    sectionCount += 1
                }
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
    
    private func heartTracking() {
        Analytics.logEvent(Tracking.Select.clickHeartFeed, parameters: nil)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func refreshCollectionView() {
        getFeedListFetchWithAPI(lastID: self.viewModel.feedInitID) {
            self.viewModel.feeds = self.viewModel.newFeeds
            if self.viewModel.feeds.count >= self.viewModel.feedCountSize {
                self.viewModel.isFirstScroll = false
            }
            self.viewModel.removeAllData()
            
            self.setData(datalist: self.viewModel.newFeeds)
            if !self.viewModel.feeds.isEmpty {
                self.collectionView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc
    private func setToastMessage() {
        let message: String = "신고 접수가 완료되었어요."
        self.showToast(x: 20, y: self.view.safeAreaInsets.top, message: message, font: .p1TitleLight)
    }
}

// MARK: - Layout
extension FeedVC {
    private func setLayout() {
        view.addSubviews([collectionView, emptyView])
        
        collectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(54)
        }
        
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyView.addSubviews([emptyImageView, emptyLabel])
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(66)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImageView.snp.bottom).offset(17)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Network

extension FeedVC {
    private func getFeedListFetchWithAPI(lastID: Int, completion: @escaping() -> Void) {
        FeedAPI(viewController: self).feedFetch(lastID: lastID, size: viewModel.feedCountSize) { response in
            switch response {
            case .success(let data):
                if let feed = data as? Feed {
                    self.stopLoadingAnimation()
                    // 통신했을때 들어오는 records가 없으면 마지막 스크롤이므로 isLastScroll = true
                    if feed.records.isEmpty {
                        self.viewModel.isLastScroll = true
                    } else {
                        self.viewModel.isLastScroll = false
                    }
                    self.viewModel.newFeeds = feed.records
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
        FeedAPI(viewController: self).feedLike(recordID: recordID) { response in
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
        return viewModel.dateList.count == 0 ? 1: viewModel.dateList.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            // isInfinitiScroll이 true이고, isLastScroll이 false일때 스크롤했을 경우만 feed 통신하도록
            if viewModel.isInfiniteScroll && !viewModel.isLastScroll {
                viewModel.isInfiniteScroll = false
                viewModel.isLastScroll = true
                
                let feedLastID = viewModel.feeds.last?.recordID ?? 0
                getFeedListFetchWithAPI(lastID: feedLastID) {
                    self.viewModel.feeds.append(contentsOf: self.viewModel.newFeeds)
                    if self.viewModel.feeds.count >= self.viewModel.feedCountSize {
                        self.viewModel.isFirstScroll = false
                    }
                    self.setData(datalist: self.viewModel.newFeeds)
                    self.collectionView.reloadData()
                    self.viewModel.isInfiniteScroll = true
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.dateList.count != 0 {
            var itemCount = 0
            var indexPath = 0
            while indexPath < viewModel.feeds.count {
                if viewModel.dateList[section] == viewModel.feeds[indexPath].date {
                    itemCount += 1
                    indexPath += 1
                } else {
                    indexPath += 1
                }
            }
            return itemCount
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.feedCVC, for: indexPath) as? FeedCVC else { return UICollectionViewCell() }
        if viewModel.dateList.count != 0 {
            
            // cell 별로 보여줄 데이터 리스트
            let dataList = viewModel.setDataList(indexPath: indexPath)
            
            print("❓ \(dataList)")
            
            cell.initCell(title: dataList.roomName, nickName: dataList.nickname, timeRecord: dataList.timerRecord, likeCount: dataList.likeNum, sparkCount: dataList.sparkCount, profileImg: dataList.profileImg, certifyingImg: dataList.certifyingImg, hasTime: true, isLiked: dataList.isLiked, recordId: dataList.recordID, indexPath: indexPath, isMyRecord: dataList.isMyRecord)
            cell.buttonDelegate = self
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if viewModel.dateList.count != 0 {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Cell.Identifier.feedHeaderView, for: indexPath) as? FeedHeaderView else { return UICollectionReusableView() }
                
                let date = viewModel.dateList[indexPath.section].split(separator: "-")
                header.dateLabel.text = "\(date[0])년 \(date[1])월 \(date[2])일"
                header.dayLabel.text = "\(viewModel.dayList[indexPath.section])"
                
                return header
                
            case UICollectionView.elementKindSectionFooter:
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Const.Cell.Identifier.feedFooterView, for: indexPath) as? FeedFooterView else { return UICollectionReusableView() }
                
                if (viewModel.isLastScroll && viewModel.isInfiniteScroll) || viewModel.isFirstScroll {
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
        if viewModel.dateList.count != 0 {
            let width = UIScreen.main.bounds.width
            let height = width*85/375
            return CGSize(width: width, height: height)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.dateList.count != 0 {
            // isInfiniteScroll이며 마지막 section일 경우에만 footer가 보이도록 한다.
            // scroll될 때는 loading이 있는 footer를 보이며, 마지막 section만 멘트가 표시된 footer가 남아있다.
            if viewModel.isInfiniteScroll && section == collectionView.numberOfSections-1 {
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
        let width: CGFloat = UIScreen.main.bounds.width
        let height: CGFloat = width*535/375
        
        return CGSize(width: width, height: height)
    }
}
 
// MARK: - FeedCellDelegate

extension FeedVC: FeedCellDelegate {
    func moreButtonTapped(recordID: Int?) {
        guard let tabBarController = tabBarController as? SparkTabBarController else { return }
        let alert = SparkActionSheet()
        alert.addAction(SparkAction("신고하기", titleType: .blackMediumTitle, handler: {
            alert.dismiss(animated: true) {
                guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.feedReport, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.feedReport) as? FeedReportVC else { return }
                
                nextVC.recordID = recordID
                
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }))
        
        alert.addSection()
        alert.addAction(SparkAction("취소", titleType: .blackBoldTitle, handler: {
            self.dismiss(animated: true, completion: nil)
        }))
        
        tabBarController.present(alert, animated: true)
    }
    
    func likeButtonTapped(recordID: Int?, indexPath: IndexPath, likeState: Bool) {
        viewModel.changeLikeState(indexPath: indexPath, likeState: likeState)
        if !likeState { heartTracking() }
        postFeedLikeWithAPI(recordID: recordID ?? 0)
    }
}
