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
        setCollectionView()
        setDelegate()
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
        
        collectionView.register(NoticeUpdateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Cell.Identifier.noticeUpdateHeaderView)
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
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            guard let updateHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Cell.Identifier.noticeUpdateHeaderView, for: indexPath) as? NoticeUpdateHeaderView else { return UICollectionReusableView() }

            return updateHeader
        case 1:
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension NoticeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            let height = UIScreen.main.bounds.width*115/375
            return CGSize(width: UIScreen.main.bounds.width, height: height)
        case 1:
            return CGSize(width: UIScreen.main.bounds.width, height: 200)
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: 200)
        }
    }
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
