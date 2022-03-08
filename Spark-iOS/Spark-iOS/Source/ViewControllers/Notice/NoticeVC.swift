//
//  NoticeVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/06.
//

import UIKit

import SnapKit

class NoticeVC: UIViewController {
    
    // MARK: - Properties
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    private var customNavigationBar = LeftButtonNavigaitonBar()
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
//        setCollectionView()
//        setDelegate()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
        
        customNavigationBar.title("알림")
            .leftButtonImage("icBackWhite")
            .leftButonAction {
                self.popToHomeVC()
            }
    }
    
    private func setCollectionView() {
        collectionViewFlowLayout.sectionHeadersPinToVisibleBounds = true
        collectionViewFlowLayout.scrollDirection = .vertical
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func popToHomeVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension NoticeVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource() {

extension NoticeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension NoticeVC: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - Network

// MARK: - Layout

extension NoticeVC {
    private func setLayout() {
        view.addSubviews([customNavigationBar, collectionView])
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
// FIXME: - 네비게이션 extension 정리후 공통으로 빼서 사용하기
extension NoticeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
