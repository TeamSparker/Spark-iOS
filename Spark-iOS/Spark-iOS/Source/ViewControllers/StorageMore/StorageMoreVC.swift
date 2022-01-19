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
    
    // MARK: - @IBOutlet Properties
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        registerXib()
        setUI()
        setLayout()
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
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.initWithBackButtonTitle(title: "아침마다 요거트 먹기", tintColor: .sparkWhite, backgroundColor: .sparkBlack)
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
        // 컬렉션뷰 크기 정하기
        // 컬렉션뷰 위드에 맞게 셀 위드 정하기
        // 셀 위드에 대해서 간격과 높이 정하기
        let cellWidth: CGFloat = collectionView.frame.width
        let cellWidthRatio: CGFloat = 160/375
        let widthHeightRatio: CGFloat = 203/160
        let cell = CGSize(width: cellWidth*cellWidthRatio, height: cellWidth*cellWidthRatio*widthHeightRatio)
        return cell
    }
    
    // TODO: 엣지 인셋 고치기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension StorageMoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.NibName.moreStorageCVC, for: indexPath) as? MoreStorageCVC else {return UICollectionViewCell()}

        return cell
    }
}

// MARK: Network

extension StorageMoreVC {
    func getMyRoomCertiWithAPI() {
        MyRoomAPI.shared.myRoomCertiFetch(roomID: 2, lastID: -1, size: 7) {  response in
            switch response {
            case .success(let data):
                if let myRoomCerti = data as? MyRoomCertification {
                    print(myRoomCerti)
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
