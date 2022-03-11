//
//  StorageVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit

import Lottie
import SnapKit

class StorageVC: UIViewController {
    
    // MARK: - Properties
    
    private var onGoingRoomList: [MyRoomRooms]? = []
    private var onGoingRoomLastID: Int = -1
    private var completeRoomList: [MyRoomRooms]? = []
    private var completeRoomLastID: Int = -1
    private var failRoomList: [MyRoomRooms]? = []
    private var failRoomLastID: Int = -1
    private var mainStatus: Int = -1
    private var fromStorageMore: Bool = false
    
    // 사이즈 임의설정
    private var myRoomCountSize: Int = 30
    private var isInfiniteScroll: Bool = false
    private var tagCount: Int = 1
    
    lazy var loadingBgView = UIImageView()
    lazy var loadingView = AnimationView(name: Const.Lottie.Name.loading)
    lazy var loadingTopView = UIView()
    
    let doingButton = StatusButton()
    let doneButton = StatusButton()
    let failButton = StatusButton()
    
    let doingLabel = UILabel()
    let doneLabel = UILabel()
    let failLabel = UILabel()
    
    let usernameSparkLabel = UILabel()
    
    var doingCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 197, width: 375, height: 520), collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    var doneCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 197, width: 375, height: 520), collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    var failCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 197, width: 375, height: 520), collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyViewUpperLabel: UILabel!
    @IBOutlet weak var emptyViewLowerLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        registerXib()
        setCarousels()
        setUI()
        setLayout()
        setAddTargets(doingButton, doneButton, failButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
        tabBarController?.tabBar.isHidden = false
        
        onGoingRoomList?.removeAll()
        completeRoomList?.removeAll()
        failRoomList?.removeAll()
        
        DispatchQueue.main.async { [self] in
            self.setLoading()
        }
        
        DispatchQueue.main.async {
            self.getOnGoingRoomWithAPI(lastID: self.onGoingRoomLastID, size: self.myRoomCountSize) {
                self.getFailRoomWithAPI(lastID: self.failRoomLastID, size: self.myRoomCountSize) {
                    self.getCompleteRoomWithAPI(lastID: self.completeRoomLastID, size: self.myRoomCountSize) {
                        self.doneCV.reloadData()
                        self.failCV.reloadData()
                        
                        if self.onGoingRoomList?.count == 0 {
                            self.emptyView.isHidden = false
                        } else {
                            self.emptyView.isHidden = true
                        }
                        
                        // 인증사진 모아보기에서 왔을 경우 버튼과 컬렉션뷰를 리셋하지 않기 위한 분기처리
                        if !self.fromStorageMore {
                            self.reSetView()
                        } else {
                            self.fromStorageMore = false
                        }
                        
                        self.loadingView.stop()
                        self.loadingView.removeFromSuperview()
                        self.loadingBgView.removeFromSuperview()
                    }
                }
            }
        }
    }
}

// MARK: - Methods

// UI및 레이아웃
extension StorageVC {
    
    private func setDelegate() {
        doingCV.delegate = self
        doingCV.dataSource = self
        doneCV.delegate = self
        doneCV.dataSource = self
        failCV.delegate = self
        failCV.dataSource = self
        doneCV.isHidden = true
        failCV.isHidden = true
    }
    
    private func registerXib() {
        let xibDoingCVName = UINib(nibName: "DoingStorageCVC", bundle: nil)
        doingCV.register(xibDoingCVName, forCellWithReuseIdentifier: "DoingStorageCVC")
        
        let xibDoneCVName = UINib(nibName: "DoneStorageCVC", bundle: nil)
        doneCV.register(xibDoneCVName, forCellWithReuseIdentifier: "DoneStorageCVC")
        
        let xibFailCVName = UINib(nibName: "FailStorageCVC", bundle: nil)
        failCV.register(xibFailCVName, forCellWithReuseIdentifier: "FailStorageCVC")
    }
    
    private func setLoading() {
        loadingBgView.image = UIImage(named: "bgLinegridForWhite")
        loadingBgView.contentMode = .scaleAspectFill
        loadingBgView.clipsToBounds = true
        view.addSubviews([loadingBgView, loadingView])
        
        loadingBgView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
        }
        
        loadingView.loopMode = .loop
        loadingView.contentMode = .scaleAspectFit
        loadingView.play()
        
        loadingTopView.backgroundColor = .sparkWhite
        
        loadingBgView.addSubview(loadingTopView)
        
        loadingTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    private func setUI() {
        usernameSparkLabel.text = """
            님의
        0가지 스파크
        """
        usernameSparkLabel.font = .h2Title
        usernameSparkLabel.textColor = .sparkBlack
        usernameSparkLabel.numberOfLines = 2
        
        doingButton.status = 0
        doingButton.backgroundColor = .clear
        doingButton.setTitle("진행중", for: .normal)
        doingButton.titleLabel?.font = .h3Subtitle
        doingButton.setTitleColor(.sparkDarkGray, for: .normal)
        doingButton.setTitleColor(.sparkDarkPinkred, for: .selected)
        doingButton.setTitleColor(.sparkDarkPinkred, for: .highlighted)
        doingButton.setTitleColor(.sparkDarkPinkred, for: .focused)
        doingButton.isSelected = true
        
        doingLabel.text = " "
        doingLabel.font = .h3Subtitle
        doingLabel.textColor = .sparkDarkPinkred
        doingLabel.font = .enMediumFont(ofSize: 14)
        
        doneButton.status = 1
        doneButton.backgroundColor = .clear
        doneButton.setTitle("완료", for: .normal)
        doneButton.titleLabel?.font = .h3Subtitle
        doneButton.setTitleColor(.sparkDarkGray, for: .normal)
        doneButton.setTitleColor(.sparkDarkPinkred, for: .selected)
        doneButton.setTitleColor(.sparkDarkPinkred, for: .highlighted)
        
        doneLabel.text = " "
        doneLabel.font = .h3Subtitle
        doneLabel.textColor = .sparkDarkGray
        doneLabel.font = .enMediumFont(ofSize: 14)
        
        failButton.status = 2
        failButton.backgroundColor = .clear
        failButton.setTitle("미완료", for: .normal)
        failButton.titleLabel?.font = .h3Subtitle
        failButton.setTitleColor(.sparkDarkGray, for: .normal)
        failButton.setTitleColor(.sparkDarkPinkred, for: .selected)
        failButton.setTitleColor(.sparkDarkPinkred, for: .highlighted)
        
        failLabel.text = " "
        failLabel.font = .h3Subtitle
        failLabel.textColor = .sparkDarkGray
        failLabel.font = .enMediumFont(ofSize: 14)
    }
    
    private func setLayout() {
        view.addSubviews([doingButton, doneButton, failButton,
                               doingCV, doneCV, failCV,
                               usernameSparkLabel, doingLabel, doneLabel,
                          failLabel])
        
        usernameSparkLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(21)
            make.leading.equalTo(doingButton)
        }
        
        doingButton.snp.makeConstraints { make in
            make.top.equalTo(usernameSparkLabel.snp.bottom).offset(23)
            make.leading.equalTo(doingCV).offset(24)
        }
        
        doingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(doingButton.snp.centerY).offset(2)
            make.leading.equalTo(doingButton.snp.trailing).offset(2)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(doingButton.snp.centerY)
            make.leading.equalTo(doingLabel.snp.trailing).offset(32)
        }
        
        doneLabel.snp.makeConstraints { make in
            make.centerY.equalTo(doneButton.snp.centerY).offset(2)
            make.leading.equalTo(doneButton.snp.trailing).offset(2)
        }
        
        failButton.snp.makeConstraints { make in
            make.centerY.equalTo(doingButton.snp.centerY)
            make.leading.equalTo(doneLabel.snp.trailing).offset(32)
        }
        
        failLabel.snp.makeConstraints { make in
            make.centerY.equalTo(failButton.snp.centerY).offset(2)
            make.leading.equalTo(failButton.snp.trailing).offset(2)
        }
        
        [doingCV, doneCV, failCV].forEach {
            $0.snp.makeConstraints { make in
                make.top.equalTo(failButton.snp.bottom).offset(14)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-11)
            }
        }
    }
    
    private func reSetView() {
        doingCV.isHidden = false
        doneCV.isHidden = true
        failCV.isHidden = true
        doingButton.isSelected = true
        doneButton.isSelected = false
        failButton.isSelected = false
        doingLabel.textColor = .sparkDarkPinkred
        doneLabel.textColor = .sparkDarkGray
        failLabel.textColor = .sparkDarkGray
        emptyViewUpperLabel.text = "아직 습관 카드가 없어요."
        emptyViewLowerLabel.text = "인증과 함께 카드를 모아보세요!"
        makeDrawAboveButton(button: doingButton)
        
        doingCV.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        doneCV.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        failCV.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}

// 애니메이션 및 버튼액션
extension StorageVC {
    private func makeDraw(rect: CGRect) {
        let animateView = LineAnimationView(frame: rect)
        
        animateView.tag = tagCount

        let anyView = self.view.viewWithTag(tagCount-1)
        let anysView = self.view.viewWithTag(tagCount-2)

        if tagCount>=2 {
            anyView?.removeFromSuperview()
        }
        if tagCount>=3 {
            anysView?.removeFromSuperview()
        }
        tagCount += 1
        
        view.addSubview(animateView)
    }
    
    // 레이아웃이 다 로딩된 후에 애니메이션 실행
    private func makeDrawAboveButton(button: UIButton) {
        self.makeDraw(rect: CGRect(x: button.frame.origin.x, y: button.frame.origin.y + 5, width: 30, height: 5))
    }

    // 버튼 타겟 설정
    private func setAddTargets(_ buttons: StatusButton...) {
        for button in buttons {
            button.addTarget(self, action: #selector(changeCollectionView), for: .touchUpInside)
        }
    }
    
    // MARK: - @objc Function
    
    @objc func changeCollectionView(sender: StatusButton) {
        let status: Int = (sender.status)
        mainStatus = status
        switch status {
        case 1:
            doingCV.isHidden = true
            doneCV.isHidden = false
            failCV.isHidden = true
            doingButton.isSelected = false
            doneButton.isSelected = true
            failButton.isSelected = false
            doingLabel.textColor = .sparkDarkGray
            doneLabel.textColor = .sparkDarkPinkred
            failLabel.textColor = .sparkDarkGray
            emptyViewUpperLabel.text = "66일간의 습관 도전!"
            emptyViewLowerLabel.text = "첫번째 성공을 이뤄내 보세요!"
            makeDrawAboveButton(button: doneButton)
            
            if completeRoomList?.count == 0 {
                emptyView.isHidden = false
            } else {
                emptyView.isHidden = true
            }
            
        case 2:
            doingCV.isHidden = true
            doneCV.isHidden = true
            failCV.isHidden = false
            doingButton.isSelected = false
            doneButton.isSelected = false
            failButton.isSelected = true
            doingLabel.textColor = .sparkDarkGray
            doneLabel.textColor = .sparkDarkGray
            failLabel.textColor = .sparkDarkPinkred
            emptyViewUpperLabel.text = "미완료된 습관이 없네요."
            emptyViewLowerLabel.text = "지금까지 아주 잘하고 있다는 증거!"
            makeDrawAboveButton(button: failButton)
            
            if failRoomList?.count == 0 {
                emptyView.isHidden = false
            } else {
                emptyView.isHidden = true
            }
            
        default:
            doingCV.isHidden = false
            doneCV.isHidden = true
            failCV.isHidden = true
            doingButton.isSelected = true
            doneButton.isSelected = false
            failButton.isSelected = false
            doingLabel.textColor = .sparkDarkPinkred
            doneLabel.textColor = .sparkDarkGray
            failLabel.textColor = .sparkDarkGray
            emptyViewUpperLabel.text = "아직 습관 카드가 없어요."
            emptyViewLowerLabel.text = "인증과 함께 카드를 모아보세요!"
            makeDrawAboveButton(button: doingButton)

            if onGoingRoomList?.count == 0 {
                emptyView.isHidden = false
            } else {
                emptyView.isHidden = true
            }
        }
    }
}

// MARK: - extension Methods

// Carousel 레이아웃 세팅
extension StorageVC {
    private func setCarousels() {
        setCarouselLayout(collectionView: doingCV)
        setCarouselLayout(collectionView: doneCV)
        setCarouselLayout(collectionView: failCV)
    }
    
    // 컬렉션뷰의 레이아웃을 캐러셀 형식으로 변환시키는 함수
    private func setCarouselLayout(collectionView: UICollectionView) {
        let layout = CarouselLayout()
        
        let centerItemWidthScale: CGFloat = (UIScreen.main.bounds.width-48)/UIScreen.main.bounds.width
        let centerItemHeightScale: CGFloat = 1
        let centerItemSizeScale: CGFloat = UIScreen.main.bounds.height/812
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width*centerItemWidthScale, height: collectionView.frame.height*centerItemHeightScale*centerItemSizeScale)

        layout.sideItemScale = 464/520
        layout.spacing = 12
        layout.sideItemAlpha = 0.4
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
}

// MARK: collectionView Delegate

extension StorageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case doingCV:
            return onGoingRoomList?.count ?? 0
        case doneCV:
            return completeRoomList?.count ?? 0
        case failCV:
            return failRoomList?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case doingCV:
            guard let onGoingRoomList = onGoingRoomList else { return UICollectionViewCell()}
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.doingStorageCVC, for: indexPath) as? DoingStorageCVC else { return UICollectionViewCell() }
            
            cell.initCell(roomName: onGoingRoomList[indexPath.row].roomName,
                          leftDay: onGoingRoomList[indexPath.row].leftDay,
                          thumbnail: onGoingRoomList[indexPath.row].thumbnail,
                          sparkCount: onGoingRoomList[indexPath.row].totalReceivedSpark,
                          startDate: onGoingRoomList[indexPath.row].startDate,
                          endDate: onGoingRoomList[indexPath.row].endDate)
            cell.layer.cornerRadius = 4
            
            return cell
            
        case doneCV:
            guard let completeRoomList = completeRoomList else { return UICollectionViewCell()}
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.doneStorageCVC, for: indexPath) as? DoneStorageCVC else { return UICollectionViewCell()}
            
            cell.initCell(roomName: completeRoomList[indexPath.row].roomName,
                          thumbnail: completeRoomList[indexPath.row].thumbnail,
                          sparkCount: completeRoomList[indexPath.row].totalReceivedSpark,
                          startDate: completeRoomList[indexPath.row].startDate,
                          endDate: completeRoomList[indexPath.row].endDate,
                          comment: completeRoomList[indexPath.row].comment ?? "")
            cell.layer.cornerRadius = 4
            
            return cell
        default:
            guard let failRoomList = failRoomList else { return UICollectionViewCell()}
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.failStorageCVC, for: indexPath) as? FailStorageCVC else { return UICollectionViewCell() }
            
            cell.initCell(roomName: failRoomList[indexPath.row].roomName,
                          failDay: failRoomList[indexPath.row].failDay ?? 0,
                          thumbnail: failRoomList[indexPath.row].thumbnail,
                          sparkCount: failRoomList[indexPath.row].totalReceivedSpark,
                          startDate: failRoomList[indexPath.row].startDate,
                          endDate: failRoomList[indexPath.row].endDate)
            cell.layer.cornerRadius = 4
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextSB = UIStoryboard.init(name: Const.Storyboard.Name.storageMore, bundle: nil)

        guard let nextVC = nextSB.instantiateViewController(identifier: Const.ViewController.Identifier.storageMore) as? StorageMoreVC else {return}
        
        switch collectionView {
        case doingCV:
            nextVC.roomID = onGoingRoomList?[indexPath.row].roomID
            nextVC.titleText = onGoingRoomList?[indexPath.row].roomName
            nextVC.thumbnailURL = onGoingRoomList?[indexPath.row].thumbnail
        case doneCV:
            nextVC.roomID = completeRoomList?[indexPath.row].roomID
            nextVC.titleText = completeRoomList?[indexPath.row].roomName
            nextVC.thumbnailURL = completeRoomList?[indexPath.row].thumbnail
        case failCV:
            nextVC.roomID = failRoomList?[indexPath.row].roomID
            nextVC.titleText = failRoomList?[indexPath.row].roomName
            nextVC.thumbnailURL = failRoomList?[indexPath.row].thumbnail
        default:
            return
        }

        fromStorageMore = true
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == doingCV {
            if scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.width {
                if isInfiniteScroll {
                    isInfiniteScroll = false
                    
                    onGoingRoomLastID = onGoingRoomList?.last?.roomID ?? 0
                    getOnGoingRoomWithAPI(lastID: onGoingRoomLastID, size: myRoomCountSize) {
                        self.isInfiniteScroll = true
                    }
                }
            }
        } else if scrollView == doneCV {
            if scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.width {
                if isInfiniteScroll {
                    isInfiniteScroll = false
                    
                    completeRoomLastID = completeRoomList?.last?.roomID ?? 0
                    getCompleteRoomWithAPI(lastID: completeRoomLastID, size: myRoomCountSize) {
                        self.isInfiniteScroll = true
                    }
                }
            }
        } else {
            if scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.width {
                if isInfiniteScroll {
                    isInfiniteScroll = false
                    
                    failRoomLastID = failRoomList?.last?.roomID ?? 0
                    getFailRoomWithAPI(lastID: failRoomLastID, size: myRoomCountSize) {
                        self.isInfiniteScroll = true
                    }
                }
            }
        }
    }
}

// MARK: Networks

extension StorageVC {
    
    func getOnGoingRoomWithAPI(lastID: Int, size: Int, completion: @escaping () -> Void) {
        MyRoomAPI.shared.myRoomFetch(roomType: "ONGOING", lastID: lastID, size: size) {  response in
            switch response {
            case .success(let data):
                if let myRoom = data as? MyRoom {
                    self.usernameSparkLabel.text = """
                    \(myRoom.nickname)님의
                    \(myRoom.totalRoomNum)가지 스파크
                    """
                    self.doingLabel.text = String(myRoom.ongoingRoomNum)
                    self.doneLabel.text = String(myRoom.completeRoomNum)
                    self.failLabel.text = String(myRoom.failRoomNum)
                    self.onGoingRoomList?.append(contentsOf: myRoom.rooms ?? [])
                    self.doingCV.reloadData()
                }
                 
                completion()
            case .requestErr(let message):
                print("getOnGoingWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getOnGoingWithAPI - pathErr")
            case .serverErr:
                print("getOnGoingWithAPI - serverErr")
            case .networkFail:
                print("getOnGoingWithAPI - networkFail")
            }
        }
    }
    
    func getFailRoomWithAPI(lastID: Int, size: Int, completion: @escaping () -> Void) {
        MyRoomAPI.shared.myRoomFetch(roomType: "FAIL", lastID: lastID, size: size) {  response in
            switch response {
            case .success(let data):
                if let myRoom = data as? MyRoom {
                    self.failRoomList?.append(contentsOf: myRoom.rooms ?? [])
                }
                 
                completion()
            case .requestErr(let message):
                print("getFailRoomWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getFailRoomWithAPI - pathErr")
            case .serverErr:
                print("getFailRoomWithAPI - serverErr")
            case .networkFail:
                print("getFailRoomWithAPI - networkFail")
            }
        }
    }
    
    func getCompleteRoomWithAPI(lastID: Int, size: Int, completion: @escaping () -> Void) {
        MyRoomAPI.shared.myRoomFetch(roomType: "COMPLETE", lastID: lastID, size: size) {  response in
            switch response {
            case .success(let data):
                if let myRoom = data as? MyRoom {
                    self.completeRoomList?.append(contentsOf: myRoom.rooms ?? [])
                }
                 
                completion()
            case .requestErr(let message):
                print("getCompleteRoomWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getCompleteRoomWithAPI - pathErr")
            case .serverErr:
                print("getCompleteRoomWithAPI - serverErr")
            case .networkFail:
                print("getCompleteRoomWithAPI - networkFail")
            }
        }
    }
}
