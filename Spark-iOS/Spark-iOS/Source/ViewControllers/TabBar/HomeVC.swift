//
//  MainVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import UIKit

class HomeVC: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
}

// MARK: - Methods

extension HomeVC {
    private func setUI() {
        // set navigationController
        navigationController?.initWithTwoCustomButtons(navigationItem: self.navigationItem,
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
    }
    
    private func setDelegate() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
    }
    
    // MARK: - @objc
    
    // TODO: - 화면전환 코드 생성
    
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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
}
