//
//  MainVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import UIKit

import Lottie
import SnapKit
import JJFloatingActionButton

class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private var habitRoomList: [Room]? = []
    private var habitRoomLastID: Int = -1
    private var habitRoomCountSize: Int = 8
    private var isInfiniteScroll: Bool = true
    
    lazy var loadingBgView = UIImageView()
    lazy var loadingView = AnimationView(name: Const.Lottie.Name.loading)
    lazy var refreshControl = UIRefreshControl()
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var customNavigationBar: RightTwoButtonNavigationBar!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        registerXib()
        initRefreshControl()
        setNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
        NotificationCenter.default.post(name: .appearFloatingButton, object: nil)
        
        self.habitRoomLastID = -1
        self.habitRoomList?.removeAll()
        
        DispatchQueue.main.async {
            self.setLoading()
        }
        
        DispatchQueue.main.async {
            self.habitRoomFetchWithAPI(lastID: self.habitRoomLastID) {
                self.mainCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
    }
}

// MARK: - Methods

extension HomeVC {
    private func setUI() {
        bgView.contentMode = .scaleAspectFill
        
        // set navigation bar.
        customNavigationBar
            .buttonsImage("icProfile", "icNotice")
            .actions({
                self.presentToMypageVC()
            }, {
                self.pushToNoticeVC()
            })
        
        // set collectionView
        mainCollectionView.backgroundColor = .clear
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = .zero
        flowLayout.scrollDirection = .vertical
        mainCollectionView.collectionViewLayout = flowLayout
        
        mainCollectionView.indicatorStyle = .black
        mainCollectionView.showsVerticalScrollIndicator = true
        mainCollectionView.isScrollEnabled = false
    }
    
    private func setDelegate() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
    }
    
    private func registerXib() {
        mainCollectionView.register(UINib(nibName: Const.Cell.Identifier.homeHabitCVC, bundle: nil), forCellWithReuseIdentifier: Const.Cell.Identifier.homeHabitCVC)
        mainCollectionView.register(UINib(nibName: Const.Cell.Identifier.homeWaitingCVC, bundle: nil), forCellWithReuseIdentifier: Const.Cell.Identifier.homeWaitingCVC)
        mainCollectionView.register(UINib(nibName: Const.Cell.Identifier.homeEmptyCVC, bundle: nil), forCellWithReuseIdentifier: Const.Cell.Identifier.homeEmptyCVC)
    }
    
    private func setLoading() {
        loadingBgView.image = UIImage(named: "bgLinegridForWhite")
        loadingBgView.contentMode = .scaleAspectFill
        loadingBgView.clipsToBounds = true
        view.addSubviews([loadingBgView, loadingView, customNavigationBar])
        
        loadingBgView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        loadingView.loopMode = .loop
        loadingView.contentMode = .scaleAspectFit
        loadingView.play()
        
        let customNavigationBar = RightTwoButtonNavigationBar().buttonsImage("icProfile", "icNotice")
            .actions({
                self.presentToMypageVC()
            }, {
                self.pushToNoticeVC()
            })
        
        loadingBgView.addSubview(customNavigationBar)
        
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    private func initRefreshControl() {
        refreshControl.tintColor = .sparkPinkred
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        mainCollectionView.refreshControl = refreshControl
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setToastMessage(_:)), name: NSNotification.Name("leaveRoom"), object: nil)
    }
    
    // MARK: - Screen Change
    
    private func presentToMypageVC() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.mypage, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mypage) as? MypageVC else { return }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }

    private func pushToNoticeVC() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.notice, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.notice) as? NoticeVC else { return }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - Objc Methods
    
    @objc
    private func refreshCollectionView() {
        habitRoomLastID = -1
        habitRoomList?.removeAll()
        
        DispatchQueue.main.async {
            self.habitRoomFetchWithAPI(lastID: self.habitRoomLastID) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc
    private func setToastMessage(_ notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            guard var roomName: String = notification.userInfo?["roomName"] as? String else { return }
            guard let waiting: Bool = notification.userInfo?["waitingRoom"] as? Bool else { return }
            let message: String
        
            if roomName.count > 8 {
                let index = roomName.index(roomName.startIndex, offsetBy: 8)
                roomName = roomName[..<index] + "..."
            }
            
            if waiting {
                message = "'\(roomName)' 대기방을 나갔어요."
            } else {
                message = "'\(roomName)' 방을 나갔어요."
            }
            self.showToast(x: 20, y: self.view.safeAreaInsets.top, message: message, font: .p1TitleLight)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if isInfiniteScroll {
                isInfiniteScroll = false
                
                habitRoomLastID = habitRoomList?.last?.roomID ?? 0
                habitRoomFetchWithAPI(lastID: habitRoomLastID) {
                    self.isInfiniteScroll = true
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let habitRoomList = habitRoomList else { return }
        if habitRoomList.count != 0 {
            if habitRoomList[indexPath.item].isStarted == true {
                // 습관방
                guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.habitRoom, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.habitRoom) as? HabitRoomVC else { return }
                nextVC.roomID = habitRoomList[indexPath.item].roomID
                
                navigationController?.pushViewController(nextVC, animated: true)
            } else {
                // 대기방
                guard let waitingVC = UIStoryboard(name: Const.Storyboard.Name.waiting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.waiting) as? WaitingVC else { return }
                waitingVC.roomId = habitRoomList[indexPath.item].roomID
                waitingVC.fromWhereStatus = .fromHome
                waitingVC.roomName = habitRoomList[indexPath.item].roomName
                
                navigationController?.pushViewController(waitingVC, animated: true)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = habitRoomList?.count ?? 0
        return count == 0 ? 1 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitRoomList = habitRoomList else { return UICollectionViewCell()}
        if habitRoomList.count != 0 {
            collectionView.isScrollEnabled = true
            if habitRoomList[indexPath.item].isStarted == false {
                guard let waitingCVC = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.homeWaitingCVC, for: indexPath) as? HomeWaitingCVC else { return UICollectionViewCell() }
                
                waitingCVC.initCell(roomName: habitRoomList[indexPath.item].roomName)
                
                return waitingCVC
            } else {
                guard let habitCVC = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.homeHabitCVC, for: indexPath) as? HomeHabitCVC else { return UICollectionViewCell() }
                
                habitCVC.initCell(roomName: habitRoomList[indexPath.item].roomName,
                                  leftDay: habitRoomList[indexPath.item].leftDay ?? 0,
                                  profileImg: habitRoomList[indexPath.item].profileImg,
                                  life: habitRoomList[indexPath.item].life ?? 0,
                                  status: habitRoomList[indexPath.item].myStatus ?? "NONE",
                                  memberNum: habitRoomList[indexPath.item].memberNum ?? 0,
                                  doneMemberNum: habitRoomList[indexPath.item].doneMemberNum ?? 0)
                
                return habitCVC
            }
        } else {
            // empty view.
            collectionView.isScrollEnabled = false
            guard let emptyCVC = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.homeEmptyCVC, for: indexPath) as? HomeEmptyCVC else { return UICollectionViewCell()}

            return emptyCVC
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let habitRoomList = habitRoomList else { return .zero }
        
        let cellWidth = collectionView.frame.width - 40
        let collectionViewHeight = collectionView.frame.height
        
        if habitRoomList.count != 0 {
            if habitRoomList[indexPath.item].isStarted == false {
                let waitingCellHeight = cellWidth * (98/335)
                return CGSize(width: cellWidth, height: waitingCellHeight)
            } else {
                let habitCellHeight = cellWidth * (196/335)
                return CGSize(width: cellWidth, height: habitCellHeight)
            }
        } else {
            return CGSize(width: cellWidth, height: collectionViewHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
    }
}

// MARK: - Network

extension HomeVC {
    private func habitRoomFetchWithAPI(lastID: Int, completion: @escaping () -> Void) {
        HomeAPI.shared.habitRoomFetch(lastID: lastID, size: habitRoomCountSize) { response in
            switch response {
            case .success(let data):
                self.loadingView.stop()
                self.loadingView.removeFromSuperview()
                self.loadingBgView.removeFromSuperview()
                if let habitRooms = data as? HabitRoom {
                    self.habitRoomList?.append(contentsOf: habitRooms.rooms)
                    self.mainCollectionView.reloadData()
                }
                
                completion()
            case .requestErr(let message):
                print("habitRoomFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("habitRoomFetchWithAPI - pathErr")
            case .serverErr:
                print("habitRoomFetchWithAPI - serverErr")
            case .networkFail:
                print("habitRoomFetchWithAPI - networkFail")
            }
        }
    }
}
