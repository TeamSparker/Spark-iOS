//
//  HabitRoomGuideVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/15.
//

import UIKit

import SnapKit

class HabitRoomGuideVC: UIViewController {
    
    // MARK: - Properties
    
    private let popupView = UIView()
    private let titleLabel = UILabel()
//    private let flakeBackgroundView = UIImageView()
    private let pageControl = UIPageControl()
    private let closeButton = UIButton()
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
        setCollectionView()
        setDelegate()
    }
    
    // MARK: - Method
    
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        popupView.backgroundColor = .sparkWhite
        popupView.layer.cornerRadius = 2
        
        titleLabel.text = "66일간의 습관 성공 Tip!"
        titleLabel.font = .h3Subtitle
        titleLabel.textColor = .sparkMoreDeepGray
        titleLabel.textAlignment = .center
        
        closeButton.setTitle("닫기", for: .normal)
        closeButton.setTitleColor(.sparkPinkred, for: .normal)
        closeButton.titleLabel?.font = .btn2
        closeButton.alpha = 0
        
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .sparkLightGray
        pageControl.currentPageIndicatorTintColor = .sparkBrightPinkred
        pageControl.isUserInteractionEnabled = false
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled  = true
        
        collectionViewFlowLayout.collectionView?.isPagingEnabled = true
        collectionViewFlowLayout.scrollDirection = .horizontal
        
        collectionView.register(HabitRoomGuideCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.habitRoomGuideCVC)
    }
    
    private func setAddTarget() {
        closeButton.addTarget(self, action: #selector(dismissHabitRoomGuideVC), for: .touchUpInside)
    }
    
    // MARK: - @objc
    
    @objc
    private func dismissHabitRoomGuideVC() {
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension HabitRoomGuideVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.habitRoomGuideCVC, for: indexPath) as? HabitRoomGuideCVC else { return UICollectionViewCell() }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HabitRoomGuideVC: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.collectionView.frame.width)
        pageControl.currentPage = page
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !closeButton.isHidden {
            UIView.animate(withDuration: 0.03) {
                self.closeButton.alpha = 0
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x + 1 >= scrollView.contentSize.width - scrollView.frame.size.width {
            UIView.animate(withDuration: 0.1) {
                self.closeButton.alpha = 1
            }
        } else {
            closeButton.alpha = 0
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HabitRoomGuideVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = popupView.frame.width
        let heigth: CGFloat = collectionView.frame.height
        return CGSize(width: width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Layout

extension HabitRoomGuideVC {
    private func setLayout() {
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo((UIScreen.main.bounds.width - 40) * 396 / 335)
        }
        
        popupView.addSubviews([titleLabel, collectionView, pageControl,
                               closeButton])
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(28)
            make.height.equalTo(21)
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(popupView.snp.height).multipliedBy(0.6)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(34)
            make.bottom.equalToSuperview().inset(36)
        }
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
