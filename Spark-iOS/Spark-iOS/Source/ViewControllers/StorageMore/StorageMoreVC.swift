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
    private var myRoomCountSize: Int = 8
    private var isInfiniteScroll: Bool = true
    
    private var myRoomCertificationList: [CertiRecord]? = []
    private var myRoomCertificationLastID: Int = -1
    
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
            self.getMyRoomCertiWithAPI(lastID: myRoomCertificationLastID, size: myRoomCountSize) {
                storageMoreCV.reloadData()
            }
        }
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
        view.backgroundColor = .sparkBlack
        navigationController?.isNavigationBarHidden = false
        navigationController?.initWithBackButtonTitle(title: titleText ?? "", tintColor: .sparkWhite, backgroundColor: .sparkBlack)

        tabBarController?.tabBar.isHidden = true
    }
    
    private func setLayout() {
        view.addSubview(storageMoreCV)
        storageMoreCV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - @objc
    
    @objc
    private func popToStorageVC() {
        navigationController?.popViewController(animated: true)
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
        
        cell.initCell(leftDay: myRoomCertificationList?[indexPath.row].leftDay ?? 0,
                      mainImage: myRoomCertificationList?[indexPath.row].certifyingImg ?? "",
                      sparkCount: myRoomCertificationList?[indexPath.row].sparkNum ?? 0,
                      status: myRoomCertificationList?[indexPath.row].status ?? "", timerCount: nil)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if isInfiniteScroll {
                isInfiniteScroll = false
                
                myRoomCertificationLastID = myRoomCertificationList?.last?.recordID ?? 0
                getMyRoomCertiWithAPI(lastID: myRoomCertificationLastID, size: myRoomCountSize) {
                    self.isInfiniteScroll = true
                }
            }
        }
    }
}

// MARK: Network

extension StorageMoreVC {
    func getMyRoomCertiWithAPI(lastID: Int, size: Int, completion: @escaping () -> Void) {
        MyRoomAPI.shared.myRoomCertiFetch(roomID: roomID ?? 0, lastID: lastID, size: size) {  response in
            switch response {
            case .success(let data):
                if let myRoomCerti = data as? MyRoomCertification {
                    self.myRoomCertificationList?.append(contentsOf: myRoomCerti.records ?? [])
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
}
