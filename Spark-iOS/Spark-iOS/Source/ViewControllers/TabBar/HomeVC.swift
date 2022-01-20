//
//  MainVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import UIKit

import SnapKit
import JJFloatingActionButton

class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private var habitRoomList: [Room]? = []
    private var habitRoomLastID: Int = -1
    
    private var habitRoomCountSize: Int = 8
    private var isInfiniteScroll: Bool = true
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .appearFloatingButton, object: nil)
        
        self.habitRoomLastID = -1
        self.habitRoomList?.removeAll()
        // 다른탭에서 돌아올때 엠티뷰가 habitRoomList 갯수만큼 여러개 등장하던 부분 해결.
        self.mainCollectionView.reloadData()
        
//        DispatchQueue.main.async {
            // TODO: - 로딩창붙이기 위한 dispatch queue
//        }
        
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
        // set navigationController
        navigationController?.initWithRightTwoCustomButtons(navigationItem: self.navigationItem,
                                                            tintColor: .sparkBlack,
                                                            backgroundColor: .sparkWhite,
                                                            firstButtonSelector: #selector(presentToProfileVC),
                                                            secondButtonSelector: #selector(presentToAertVC))
        
        // set collectionView
        print("🥕collectionView", mainCollectionView.frame.height)
        print("🥕collectionView.origin", mainCollectionView.frame.origin)
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
        mainCollectionView.register(UINib(nibName: Const.Xib.NibName.homeHabitCVC, bundle: nil), forCellWithReuseIdentifier: Const.Xib.NibName.homeHabitCVC)
        mainCollectionView.register(UINib(nibName: Const.Xib.NibName.homeWaitingCVC, bundle: nil), forCellWithReuseIdentifier: Const.Xib.NibName.homeWaitingCVC)
        mainCollectionView.register(UINib(nibName: Const.Xib.NibName.homeEmptyCVC, bundle: nil), forCellWithReuseIdentifier: Const.Xib.NibName.homeEmptyCVC)
    }
    
    // TODO: - 화면전환
    
    @objc
    private func presentToProfileVC() {
        
    }
    
    @objc
    private func presentToAertVC() {
        
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
                waitingVC.isFromHome = true
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
//            mainCollectionView.isScrollEnabled = true
            print("⚡️collectionView", mainCollectionView.frame.height)
            if habitRoomList[indexPath.item].isStarted == false {
                guard let waitingCVC = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.NibName.homeWaitingCVC, for: indexPath) as? HomeWaitingCVC else { return UICollectionViewCell() }
                
                waitingCVC.initCell(roomName: habitRoomList[indexPath.item].roomName)
                
                return waitingCVC
            } else {
                guard let habitCVC = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.NibName.homeHabitCVC, for: indexPath) as? HomeHabitCVC else { return UICollectionViewCell() }
                
                habitCVC.initCell(roomName: habitRoomList[indexPath.item].roomName,
                                  leftDay: habitRoomList[indexPath.item].leftDay ?? 0,
                                  profileImg: habitRoomList[indexPath.item].profileImg,
                                  life: habitRoomList[indexPath.item].life ?? 0,
                                  isDone: habitRoomList[indexPath.item].isDone,
                                  memberNum: habitRoomList[indexPath.item].memberNum ?? 0,
                                  doneMemberNum: habitRoomList[indexPath.item].doneMemberNum ?? 0)
                
                return habitCVC
            }
        } else {
            print("⚡️collectionView", mainCollectionView.frame.height)
            print("⚡️collectionView.origin", mainCollectionView.frame.origin)
            // empty view.
            guard let emptyCVC = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.NibName.homeEmptyCVC, for: indexPath) as? HomeEmptyCVC else { return UICollectionViewCell()}

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
                if let habitRooms = data as? HabitRoom {
                    self.habitRoomList?.append(contentsOf: habitRooms.rooms)
                    self.mainCollectionView.reloadData()
                }
                
                // FIXME: - 아래의 목적인데 한번 체크해야할듯
                // 성공적으로 한번의 통신이 마무리된 후 무한스크롤 허용. 즉, 연속적으로 통신을 요청하지 않게 하기 위함.
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
