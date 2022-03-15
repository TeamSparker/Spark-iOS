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
//    private let guideLabel = UILabel()
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
//        setDelegate()
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
        
//        guideLabel.text = "습관방의 생명은 오직 3개,\n매일 자정까지 잊지 말고 인증하기!"
//        guideLabel.font = .p1TitleLight
//        guideLabel.textColor = .sparkDeepGray
//        guideLabel.textAlignment = .center
        
        closeButton.setTitle("닫기", for: .normal)
        closeButton.setTitleColor(.sparkPinkred, for: .normal)
        closeButton.titleLabel?.font = .btn2
        
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
        
        collectionView.backgroundColor = .yellow
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
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension HabitRoomGuideVC: UICollectionViewDelegate {
    
}

// MARK: - Layout

extension HabitRoomGuideVC {
    private func setLayout() {
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo((UIScreen.main.bounds.width - 40) * 396 / 335) // (UIScreen.main.bounds.width - 40) * 396 / 335
        }
        
        popupView.addSubviews([titleLabel, collectionView, pageControl, closeButton]) // guideLabel
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(28)
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(239)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(34)
        }
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
