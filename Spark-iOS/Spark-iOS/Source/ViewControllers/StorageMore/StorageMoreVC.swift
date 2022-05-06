//
//  StorageMoreVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class StorageMoreVC: UIViewController {
    
    // MARK: - Properties
    
    var roomID: Int?
    var titleText: String?
    var thumbnailURL: String?
    
    weak var sendThumnailURLDelegate: SendThumbnailURLDelegate?
    
    private var selectedIndexPath: IndexPath?
    private var selectedRecordId: Int?
    private var isChangingImageView: Bool = false
    private var myRoomCountSize: Int = 8
    private var isInfiniteScroll: Bool = true
    
    private var myRoomCertificationList: [CertiRecord]? = []
    private var myRoomCertificationLastID: Int = -1
    
    private let customNavigationBar = LeftRightButtonsNavigationBar()
    
    var storageMoreCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 120, width: 375, height: 520), collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.indicatorStyle = .white
        cv.showsVerticalScrollIndicator = true
        
        return cv
    }()
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        registerXib()
        setUI()
        setLayout()
        
        DispatchQueue.main.async { [self] in
            if self.isChangingImageView {
                self.getMyRoomCertiChangeWithAPI(lastID: myRoomCertificationLastID, size: myRoomCountSize) { [self] in
                    storageMoreCV.reloadData()
                }
            } else {
                self.getMyRoomCertiWithAPI(lastID: myRoomCertificationLastID, size: myRoomCountSize) { [self] in
                    storageMoreCV.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBar()
    }
}

// MARK: - Methods

extension StorageMoreVC {
    private func setDelegate() {
        storageMoreCV.delegate = self
        storageMoreCV.dataSource = self
    }
    
    private func registerXib() {
        let xibCollectionViewName = UINib(nibName: "MoreStorageCVC", bundle: nil)
        storageMoreCV.register(xibCollectionViewName, forCellWithReuseIdentifier: "MoreStorageCVC")
    }
    
    private func setUI() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        if !isChangingImageView {
            customNavigationBar.title(titleText ?? "")
                .tintColor(.sparkWhite)
                .backgroundColor(.sparkBlack)
                .leftButtonImage("icBackWhite")
                .leftButtonAction {
                    self.popToStorageVC()
                }
                .rightButtonImage("icMoreVerticalWhite")
                .rightButtonAction {
                    self.presentToMoreAlert()
                }
        } else {
            customNavigationBar.title(titleText ?? "")
                .tintColor(.sparkWhite)
                .backgroundColor(.sparkBlack)
                .leftButtonTitle("취소")
                .leftButtonAction {
                    self.dismiss(animated: true, completion: nil)
                }
                .rightButtonPinkTitle("완료")
                .rightButtonAction {
                    if let selected = self.selectedRecordId {
                        self.myRoomChangeThumbnailWithAPI(roomId: self.roomID ?? 0, recordId: selected )
                    } else {
                        self.dismiss(animated: true)
                    }
                }
        }
    }
    
    private func setTabBar() {
        guard let tabBarController = tabBarController as? SparkTabBarController else { return }
        tabBarController.sparkTabBar.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews([customNavigationBar, storageMoreCV])
        
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        storageMoreCV.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // Screen Change
    
    private func popToStorageVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func presentToMoreAlert() {
        let alert = SparkActionSheet()
        alert.addAction(SparkAction("대표 이미지 변경", titleType: .blackMediumTitle, handler: {
            alert.dismiss(animated: true) {
                let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.storageMore, bundle: nil)

                guard let nextVC = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.storageMore) as? StorageMoreVC else {return}
                
                nextVC.roomID = self.roomID
                nextVC.titleText = "대표 이미지 변경"
                nextVC.thumbnailURL = self.thumbnailURL
                nextVC.isChangingImageView = true
                nextVC.sendThumnailURLDelegate = self

                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
            }
        }))
        
        alert.addSection()
        
        alert.addAction(SparkAction("취소", titleType: .blackBoldTitle, handler: {
            alert.animatedDismiss(completion: nil)
        }))
        
        present(alert, animated: true)
    }
}

// MARK: - collectionView Delegate

extension StorageMoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 양쪽 inset 40 + inter item spacing 15
        let cellWidth: CGFloat = (collectionView.frame.width - 55) / 2
        let cellHeight: CGFloat = (cellWidth * (187/160))
        
        let cell = CGSize(width: cellWidth, height: cellHeight)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension StorageMoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if myRoomCertificationList?.last?.leftDay == 66 {
            return ((myRoomCertificationList?.count ?? 0) - 1)
        } else {
            return myRoomCertificationList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.moreStorageCVC, for: indexPath) as? MoreStorageCVC else {return UICollectionViewCell()}
        
        cell.isChangingImageView = self.isChangingImageView
        
        if !isChangingImageView {
            cell.initCell(leftDay: myRoomCertificationList?[indexPath.row].leftDay ?? 0,
                          mainImage: myRoomCertificationList?[indexPath.row].certifyingImg ?? "",
                          sparkCount: myRoomCertificationList?[indexPath.row].sparkNum ?? 0,
                          status: myRoomCertificationList?[indexPath.row].status ?? "", timerCount: myRoomCertificationList?[indexPath.row].timerRecord ?? nil)
        } else {
            cell.updateImage(mainImage: myRoomCertificationList?[indexPath.row].certifyingImg ?? "", status: myRoomCertificationList?[indexPath.row].status ?? "")
            
            // 처음 대표이미지 변경 뷰로 왔을 때, 선택을 하지 않았으며 현재 셀의 인증사진 URL과 카드의 대표이미지 URL이 같은 경우 이미 선택된 상태로 만들어주기
            if (self.selectedIndexPath == nil)&&(thumbnailURL == myRoomCertificationList?[indexPath.row].certifyingImg) {
                DispatchQueue.main.async {
                    // selectItem 코드를 넣지 않으면 중복선택이 되어버리는 오류가 발생함
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                }
            }
            
            // 선택을 한 경우, 무한스크롤로 인한 reloadData 시에도 선택된 셀이 유지되도록 함
            if self.selectedIndexPath == indexPath {
                DispatchQueue.main.async {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.selectedRecordId = myRoomCertificationList?[indexPath.row].recordID
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if isInfiniteScroll {
                isInfiniteScroll = false
                
                myRoomCertificationLastID = myRoomCertificationList?.last?.recordID ?? 0
                
                if isChangingImageView {
                    getMyRoomCertiChangeWithAPI(lastID: myRoomCertificationLastID, size: myRoomCountSize) {
                        self.isInfiniteScroll = true
                    }
                } else {
                    getMyRoomCertiWithAPI(lastID: myRoomCertificationLastID, size: myRoomCountSize) {
                        self.isInfiniteScroll = true
                    }
                }
            }
        }
    }
}

// MARK: Network

extension StorageMoreVC {
    func getMyRoomCertiWithAPI(lastID: Int, size: Int, completion: @escaping () -> Void) {
        MyRoomAPI(viewController: self).myRoomCertiFetch(roomID: roomID ?? 0, lastID: lastID, size: size) {  response in
            switch response {
            case .success(let data):
                if let myRoomCerti = data as? MyRoomCertification {
                    self.myRoomCertificationList?.append(contentsOf: myRoomCerti.records)
                    self.storageMoreCV.reloadData()
                }
                completion()
            case .requestErr(let message):
                print("getMyRoomCertiWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getMyRoomCertiWithAPI - pathErr")
            case .serverErr:
                print("getMyRoomCertiWithAPI - serverErr")
            case .networkFail:
                print("getMyRoomCertiWithAPI - networkFail")
            }
        }
    }
    
    func getMyRoomCertiChangeWithAPI(lastID: Int, size: Int, completion: @escaping () -> Void) {
        MyRoomAPI(viewController: self).myRoomCertiChangeFetch(roomID: roomID ?? 0, lastID: lastID, size: size) {  response in
            switch response {
            case .success(let data):
                if let myRoomCerti = data as? MyRoomCertification {
                    self.myRoomCertificationList?.append(contentsOf: myRoomCerti.records)
                    self.storageMoreCV.reloadData()
                }
                completion()
            case .requestErr(let message):
                print("getMyRoomCertiChangeWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getMyRoomCertiChangeWithAPI - pathErr")
            case .serverErr:
                print("getMyRoomCertiChangeWithAPI - serverErr")
            case .networkFail:
                print("getMyRoomCertiChangeWithAPI - networkFail")
            }
        }
    }
    
    func myRoomChangeThumbnailWithAPI(roomId: Int, recordId: Int) {
        MyRoomAPI(viewController: self).myRoomChangeThumbnail(roomId: roomId, recordId: recordId) {  response in
            switch response {
            case .success:
                self.dismiss(animated: true) {
                    // 이전 VC로 바뀐 대표이미지의 URL 전달해주기
                    self.sendThumnailURLDelegate?.sendThumbnailURL(url: self.myRoomCertificationList?[self.selectedIndexPath?.row ?? 0].certifyingImg ?? "")
                }
            case .requestErr(let message):
                print("getMyRoomCertiWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getMyRoomCertiWithAPI - pathErr")
            case .serverErr:
                print("getMyRoomCertiWithAPI - serverErr")
            case .networkFail:
                print("getMyRoomCertiWithAPI - networkFail")
            }
        }
    }
}

// MARK: - SendThumbnailDelegate Methods
extension StorageMoreVC: SendThumbnailURLDelegate {
    func sendThumbnailURL(url: String) {
        self.thumbnailURL = url
    }
}

// MARK: - UIGestureRecognizerDelegate

extension StorageMoreVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
