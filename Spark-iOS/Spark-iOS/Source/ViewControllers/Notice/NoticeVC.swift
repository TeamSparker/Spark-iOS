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
    
    private let headerView = UIView()
    private let activeButton = UIButton() // 스파커 활동
    private let noticeButton = UIButton() // 안내
    private let noticeBadgeView = UIView()
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    private var customNavigationBar = LeftButtonNavigaitonBar()
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setCollectionView()
        setAddTarget()
//        setDelegate()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.makeDrawAboveButton(button: self.activeButton)
        }
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
        
        activeButton.setTitle("스파커 활동", for: .normal)
        activeButton.setTitleColor(.sparkDarkPinkred, for: .selected)
        activeButton.setTitleColor(.sparkDarkGray, for: .normal)
        activeButton.titleLabel?.font = .h3Subtitle
        activeButton.isSelected = true
        
        noticeButton.setTitle("안내", for: .normal)
        noticeButton.setTitleColor(.sparkDarkPinkred, for: .selected)
        noticeButton.setTitleColor(.sparkDarkGray, for: .normal)
        noticeButton.titleLabel?.font = .h3Subtitle
        
        activeButton.tag = 1
        noticeButton.tag = 2
        
        noticeBadgeView.backgroundColor = .sparkDarkPinkred
        noticeBadgeView.layer.cornerRadius = 3
    }
    
    private func setCollectionView() {
        collectionView.backgroundColor = .sparkGray
        collectionViewFlowLayout.scrollDirection = .vertical
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setAddTarget() {
        activeButton.addTarget(self, action: #selector(touchActiveButton), for: .touchUpInside)
        noticeButton.addTarget(self, action: #selector(touchNoticeButton), for: .touchUpInside)
    }

    private func popToHomeVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func makeDraw(rect: CGRect, button: UIButton) {
        let animateView = LineAnimationView(frame: rect)
        
        // activeButton.tag = 1
        // noticeButton.tag = 2
        // activeTag = 3
        // noticeTag = 4
        
        animateView.tag = button.tag + 2
        
        // 기존의 모든 태그 삭제
        let activeTag = self.view.viewWithTag(3)
        let noticeTag = self.view.viewWithTag(4)
        
        activeTag?.removeFromSuperview()
        noticeTag?.removeFromSuperview()
        
        view.addSubview(animateView)
    }
    
    /// 버튼 위에 그려주는 함수
    /// - button이 headerView에 속해있기 때문에 button.frame.origin을 하면 superView인 headerView 내에서의 x, y로 잡힘.
    /// - 따라서 header.frame.origin.y 만큼을 더해서 해당 위치로 지정.
    private func makeDrawAboveButton(button: UIButton) {
        let pointY = button.frame.origin.y + headerView.frame.origin.y
        self.makeDraw(rect: CGRect(x: button.frame.origin.x, y: pointY, width: 30, height: 5), button: button)
    }
    
    // MARK: - @objc
    
    @objc
    private func touchActiveButton() {
        activeButton.isSelected = true
        noticeButton.isSelected = false
        makeDrawAboveButton(button: activeButton)
    }
    
    @objc
    private func touchNoticeButton() {
        activeButton.isSelected = false
        noticeButton.isSelected = true
        makeDrawAboveButton(button: noticeButton)
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
        view.addSubviews([customNavigationBar, headerView, collectionView])
        headerView.addSubviews([activeButton, noticeButton, noticeBadgeView])
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        activeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(26)
        }
        
        noticeButton.snp.makeConstraints { make in
            make.leading.equalTo(activeButton.snp.trailing).offset(32)
            make.centerY.equalTo(activeButton.snp.centerY)
        }
        
        noticeBadgeView.snp.makeConstraints { make in
            make.width.height.equalTo(6)
            make.bottom.equalTo(noticeButton.snp.top).offset(12)
            make.leading.equalTo(noticeButton.snp.trailing)
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
