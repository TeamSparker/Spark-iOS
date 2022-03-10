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
    private let emptyView = UIView()
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    private var customNavigationBar = LeftButtonNavigaitonBar()
    private var isActivity: Bool = true
    private var activeLastID: Int = -1
    private var activeCountSize: Int = 10
    private var isInfiniteScroll: Bool = true
    
    private var activeList: [Active] = []
    private var newNotice: Bool = false
    
    // MARK: - DummyData
    
//    let titleList = ["방방방방방방방방방방방방방방방방에서 보낸 스파크", "가나다라마바사아자차카타파하가님이 좋아한 피드", "세은님 고민중..💭", "아침 독서방 인원 변동 🚨", "센님의 인증 완료!", "가나다라마바사아자차카타파하가님이 좋아한 피드", "세은님 고민중..💭", "아침 독서방 인원 변동 🚨", "센님의 인증 완료!"]
//    let contentList = ["수아 : 💬 가나다라마바사아자차카타파하가", "가나다라마바사아자차카타파하가방 인증을 좋아해요.", "10분 독서, 오늘 좀 힘든걸? 스파크 plz", "가나다라마바사아자차카타파님이 습관방에서 나갔어요.", "10분 독서방 인증을 완료했어요.", "가나다라마바사아자차카타파하가방 인증을 좋아해요.", "10분 독서, 오늘 좀 힘든걸? 스파크 plz", "가나다라마바사아자차카타파님이 습관방에서 나갔어요.", "10분 독서방 인증을 완료했어요."]
    
    let secondTitleList = ["새로운 습관 시작 🔥", "가나다라마바사아자차카타파하가 대기방 삭제"]
    let secontContentList = ["가나다라마바사아자차카타파하방에서 가장 먼저 스파크를 보내볼까요?", "방 개설자에 의해 대기방이 삭제되었어요."]
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setCollectionView()
        setAddTarget()
        setDelegate()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.makeDrawAboveButton(button: self.activeButton)
        }
        
        getActiveNoticeFetchWithAPI(lastID: activeLastID) {
            if self.activeList.isEmpty {
                self.emptyView.isHidden = true
            } else {
                self.emptyView.isHidden = false
            }
            
            if self.newNotice {
                self.noticeBadgeView.isHidden = false
            } else {
                self.noticeBadgeView.isHidden = true
            }
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
    
    private func setEmptyView() {
        emptyImageView.image = UIImage(named: "noticeEmpty")
        emptyLabel.text = "아직 도착한 알림이 없어요.\n친구와 함께 습관에 도전해 보세요!"
        emptyLabel.textAlignment = .center
        emptyLabel.font = .h3SubtitleLight
        emptyLabel.textColor = .sparkGray
        emptyLabel.numberOfLines = 2
        
        // 서버 통신 후 처리
        collectionView.isHidden = true
        emptyView.isHidden = false
    }
    
    private func setCollectionView() {
        collectionViewFlowLayout.scrollDirection = .vertical
        
        collectionView.register(NoticeActiveCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.noticeActiveCVC)
        collectionView.register(NoticeServiceCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.noticeServiceCVC)
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
        
        // 기존의 모든 태그 삭제
        let activeTag = self.view.viewWithTag(3)
        let noticeTag = self.view.viewWithTag(4)
        
        activeTag?.removeFromSuperview()
        noticeTag?.removeFromSuperview()
        
        // 새로운 태그 추가
        animateView.tag = button.tag + 2
        
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
        
        isActivity = true
        activeLastID = -1
        getActiveNoticeFetchWithAPI(lastID: activeLastID) {
            if self.activeList.isEmpty {
                self.emptyView.isHidden = true
            } else {
                self.emptyView.isHidden = false
            }
            
            if self.newNotice {
                self.noticeBadgeView.isHidden = false
            } else {
                self.noticeBadgeView.isHidden = true
            }
        }
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: false)
    }
    
    @objc
    private func touchNoticeButton() {
        activeButton.isSelected = false
        noticeButton.isSelected = true
        makeDrawAboveButton(button: noticeButton)
        
        isActivity = false
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: false)
    }
}

// MARK: - UICollectionViewDelegate

extension NoticeVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if isInfiniteScroll {
                isInfiniteScroll = false
                
                activeLastID = activeList.last?.noticeID ?? 0
                getActiveNoticeFetchWithAPI(lastID: activeLastID) {
                    self.isInfiniteScroll = true
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource() {

extension NoticeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isActivity {
            return activeList.count
        } else {
            return secondTitleList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isActivity {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.noticeActiveCVC, for: indexPath) as? NoticeActiveCVC else { return UICollectionViewCell() }
            
            cell.initCell(title: activeList[indexPath.item].noticeTitle, content: activeList[indexPath.item].noticeContent, date: activeList[indexPath.item].day, image: activeList[indexPath.item].noticeImg, isThumbProfile: activeList[indexPath.item].isThumbProfile, newService: activeList[indexPath.item].isNew)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.noticeServiceCVC, for: indexPath) as? NoticeServiceCVC else { return UICollectionViewCell() }
            
            cell.initCell(title: secondTitleList[indexPath.row], content: secontContentList[indexPath.row], date: "1일 전")
            
            return cell
        }
    }
}

extension NoticeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let estimatedHeight: CGFloat = width*161/375
        
        if isActivity {
            let dummyCell = NoticeActiveCVC(frame: CGRect(x: 0, y: 0, width: width, height: estimatedHeight))
            
            dummyCell.initCell(title: activeList[indexPath.item].noticeTitle, content: activeList[indexPath.item].noticeContent, date: activeList[indexPath.item].day, image: activeList[indexPath.item].noticeImg, isThumbProfile: activeList[indexPath.item].isThumbProfile, newService: activeList[indexPath.item].isNew)
            dummyCell.layoutIfNeeded()
            
            let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: width, height: estimatedHeight))

            return CGSize(width: width, height: estimatedSize.height)
        } else {
            let dummyCell = NoticeServiceCVC(frame: CGRect(x: 0, y: 0, width: width, height: estimatedHeight))
            
            dummyCell.initCell(title: secondTitleList[indexPath.row], content: secontContentList[indexPath.row], date: "1일 전")
            dummyCell.layoutIfNeeded()
            
            let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: width, height: estimatedHeight))
            
            return CGSize(width: width, height: estimatedSize.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 21, right: 0)
    }
}

// MARK: - Network

extension NoticeVC {
    private func getActiveNoticeFetchWithAPI(lastID: Int, completion: @escaping() -> Void) {
        NoticeAPI.shared.activeFetch(lastID: lastID, size: activeCountSize) { response in
            switch response {
            case .success(let data):
                if let active = data as? ActiveNotice {
                    self.newNotice = active.newService
                    self.activeList.append(contentsOf: active.notices)
                    self.collectionView.reloadData()
                }
                completion()
            case .requestErr(let message):
                print("getActiveNoticeFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getActiveNoticeFetchWithAPI - pathErr")
            case .serverErr:
                print("getActiveNoticeFetchWithAPI - serverErr")
            case .networkFail:
                print("getActiveNoticeFetchWithAPI - networkFail")
            }
        }
    }
}

// MARK: - Layout

extension NoticeVC {
    private func setLayout() {
        view.addSubviews([customNavigationBar, headerView, collectionView, emptyView])
        headerView.addSubviews([activeButton, noticeButton, noticeBadgeView])
        emptyView.addSubviews([emptyImageView, emptyLabel])
        
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
        
        emptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImageView.snp.bottom).offset(23)
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
