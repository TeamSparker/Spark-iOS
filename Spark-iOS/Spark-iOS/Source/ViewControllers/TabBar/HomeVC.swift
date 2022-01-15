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
    
    private var habitRoomList = [String]()
    private var isWating = false
    
    private let floatingButton = JJFloatingActionButton()
    private let tapGestrueRecognizer = UITapGestureRecognizer()
    
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
    }
}

// MARK: - Methods

extension HomeVC {
    private func setUI() {
        // set navigationController
        navigationController?.initWithRightTwoCustomButtons(navigationItem: self.navigationItem,
                                                            tintColor: .sparkBlack,
                                                            backgroundColor: .sparkWhite,
                                                            firstButtonClosure: #selector(presentToProfileVC),
                                                            secondButtonClosure: #selector(presentToAertVC))
        
        // set collectionView
        mainCollectionView.backgroundColor = .clear
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = .zero
        flowLayout.scrollDirection = .vertical
        mainCollectionView.collectionViewLayout = flowLayout
        
        mainCollectionView.indicatorStyle = .black
        mainCollectionView.showsVerticalScrollIndicator = true
    }
    
    private func setDelegate() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
    }
    
    private func registerXib() {
        mainCollectionView.register(UINib(nibName: Const.Xib.NibName.homeHabitCVC, bundle: nil), forCellWithReuseIdentifier: Const.Xib.NibName.homeHabitCVC)
        mainCollectionView.register(UINib(nibName: Const.Xib.NibName.homeWaitingCVC, bundle: nil), forCellWithReuseIdentifier: Const.Xib.NibName.homeWaitingCVC)
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
    
}

// MARK: - UICollectionViewDataSource

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return habitRoomList.count
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isWating {
            guard let waitingCVC = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.NibName.homeWaitingCVC, for: indexPath) as? HomeWaitingCVC else { return UICollectionViewCell() }
            
            // TODO: - initCell()
            
            waitingCVC.initCell()
            
            return waitingCVC
        } else {
            guard let habitCVC = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.NibName.homeHabitCVC, for: indexPath) as? HomeHabitCVC else { return UICollectionViewCell() }
            
            // TODO: - initCell()
            
            habitCVC.initCell()
            
            return habitCVC
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        if isWating {
            let waitingCellHeight = cellWidth * (98/335)
            return CGSize(width: cellWidth, height: waitingCellHeight)
        } else {
            let habitCellHeight = cellWidth * (196/335)
            return CGSize(width: cellWidth, height: habitCellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20)
    }
}
