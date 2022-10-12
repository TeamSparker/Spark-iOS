//
//  LifeTimeLineVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/10/03.
//

import UIKit

import SnapKit

class LifeTimeLineVC: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let collectionViewFlowlayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowlayout)
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private var timelineList: [Timeline] = []
    var roomID: Int?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setDelegate()
        setCollectionView()
        setAddTarget()
        setGestureRecognizer()
        getTimelineFetchWithAPI(roomID: self.roomID ?? 0)
    }
    
    // MARK: - Custom Methods
    
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        collectionView.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width * 1.3)
        }
    }
    
    private func setCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        collectionView.register(LifeTimeLineCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.lifeTimeLineCVC)
        collectionView.register(LifeTimeLineHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Cell.Identifier.lifeTimeLineHeaderView)
        
        collectionViewFlowlayout.sectionHeadersPinToVisibleBounds = true
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        tapGestureRecognizer.delegate = self
    }
    
    private func setAddTarget() {
        tapGestureRecognizer.addTarget(self, action: #selector(dismissToHabitRoom))
    }
    
    private func setGestureRecognizer() {
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - @objc
    
    @objc
    private func dismissToHabitRoom() {
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension LifeTimeLineVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LifeTimeLineVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width
        let estimatedHeight: CGFloat = width*107/375
        
        let dummyCell = LifeTimeLineCVC(frame: CGRect(x: 0, y: 0, width: width, height: estimatedHeight))
        let data = timelineList[indexPath.row]
        dummyCell.initCell(title: data.title, subTitle: data.content, profilImg: data.profiles ?? [], day: data.day)
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: width, height: estimatedHeight))
        
        return CGSize(width: width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDataSource

extension LifeTimeLineVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timelineList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Const.Cell.Identifier.lifeTimeLineHeaderView, for: indexPath) as? LifeTimeLineHeaderView else { return UICollectionReusableView() }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = width*80/375
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.lifeTimeLineCVC, for: indexPath) as? LifeTimeLineCVC else { return UICollectionViewCell() }
        let data = timelineList[indexPath.row]
        cell.initCell(title: data.title, subTitle: data.content, profilImg: data.profiles ?? [], day: data.day)
        return cell
    }
}

// MARK: - UIGestureRecognizerDelegate

extension LifeTimeLineVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view is UICollectionViewCell) || (touch.view is UICollectionReusableView) ? false : true
    }
}

// MARK: - Network

extension LifeTimeLineVC {
    private func getTimelineFetchWithAPI(roomID: Int) {
        RoomAPI(viewController: self).fetchTimeline(roomID: roomID) { response in
            switch response {
            case .success(let data):
                if let timelines = data as? Timelines {
                    self.timelineList = timelines.timelines
                    self.collectionView.reloadData()
                }
            case .requestErr(let message):
                print("getTimelineFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getTimelineFetchWithAPI - pathErr")
            case .serverErr:
                print("getTimelineFetchWithAPI - serverErr")
            case .networkFail:
                print("getTimelineFetchWithAPI - networkFail")
            }
        }
    }
}
