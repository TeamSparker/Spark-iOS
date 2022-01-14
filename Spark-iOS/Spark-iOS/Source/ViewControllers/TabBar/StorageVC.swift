//
//  StorageVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/10.
//

import UIKit
import SnapKit

class StorageVC: UIViewController {
    
    let doingButton = MyButton()
    let doneButton = MyButton()
    let failButton = MyButton()
    
    let doingLabel = UILabel()
    let doneLabel = UILabel()
    let failLabel = UILabel()
    
    let upperLabel = UILabel()
    let lowerLabel = UILabel()
    
    var DoingCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let name = UICollectionView(frame: CGRect(x: 0,y: 197,width: 375,height: 520), collectionViewLayout: layout)
        name.backgroundColor = .clear
        
        return name
    }()
    
    var DoneCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let name = UICollectionView(frame: CGRect(x: 0,y: 197,width: 375,height: 520), collectionViewLayout: layout)
        name.backgroundColor = .clear
        
        return name
    }()
    
    var FailCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let name = UICollectionView(frame: CGRect(x: 0,y: 197,width: 375,height: 520), collectionViewLayout: layout)
        name.backgroundColor = .clear
        
        return name
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        registerXib()
        setCarousels()
        // TODO: setLayout에서 애드서브뷰 같이해주기
        addSubviews(doingButton, doneButton, failButton, DoingCV, DoneCV, FailCV)
        addSubviews(upperLabel, lowerLabel, doingLabel, doneLabel, failLabel)
        setButtons()
        addTargets(doingButton, doneButton, failButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func setDelegate() {
        DoingCV.delegate = self
        DoingCV.dataSource = self
        DoneCV.delegate = self
        DoneCV.dataSource = self
        FailCV.delegate = self
        FailCV.dataSource = self
        DoneCV.isHidden = true
        FailCV.isHidden = true
    }
    
    func registerXib() {
        let xibDoingCVName = UINib(nibName: "DoingStorageCVC", bundle: nil)
        DoingCV.register(xibDoingCVName, forCellWithReuseIdentifier: "DoingStorageCVC")
        
        let xibDoneCVName = UINib(nibName: "DoneStorageCVC", bundle: nil)
        DoneCV.register(xibDoneCVName, forCellWithReuseIdentifier: "DoneStorageCVC")
        
        let xibFailCVName = UINib(nibName: "FailStorageCVC", bundle: nil)
        FailCV.register(xibFailCVName, forCellWithReuseIdentifier: "FailStorageCVC")
    }
    
    // TODO: 컬렉션뷰 위치 스냅킷으로 잡아주기.
    
    // MARK: 버튼 레이아웃 설정
    // TODO: setUI와 setLayout으로 나눠주기
    func setButtons() {
        upperLabel.text = "나는야쿵짝지혜 님의"
        upperLabel.font = .h2Title
        upperLabel.textColor = .sparkBlack
        
        lowerLabel.text = "19가지 스파크"
        lowerLabel.font = .h2Title
        lowerLabel.textColor = .sparkBlack
        
        doingButton.statusCV = 0
        doingButton.backgroundColor = .clear
        doingButton.setTitle("진행중", for: .normal)
        doingButton.titleLabel?.font = .h3Subtitle
        doingButton.setTitleColor(.sparkDarkGray, for: .normal)
        doingButton.setTitleColor(.sparkDarkPinkred, for: .selected)
        doingButton.setTitleColor(.sparkDarkPinkred, for: .highlighted)
        doingButton.isSelected = true
        
        doingLabel.text = "6"
        doingLabel.font = .h3Subtitle
        doingLabel.textColor = .sparkDarkPinkred
        doingLabel.font = .enMediumFont(ofSize: 14)
        
        doneButton.statusCV = 1
        doneButton.backgroundColor = .clear
        doneButton.setTitle("완료", for: .normal)
        doneButton.titleLabel?.font = .h3Subtitle
        doneButton.setTitleColor(.sparkDarkGray, for: .normal)
        doneButton.setTitleColor(.sparkDarkPinkred, for: .selected)
        doneButton.setTitleColor(.sparkDarkPinkred, for: .highlighted)
        
        doneLabel.text = "12"
        doneLabel.font = .h3Subtitle
        doneLabel.textColor = .sparkDarkGray
        doneLabel.font = .enMediumFont(ofSize: 14)
        
        failButton.statusCV = 2
        failButton.backgroundColor = .clear
        failButton.setTitle("미완료", for: .normal)
        failButton.titleLabel?.font = .h3Subtitle
        failButton.setTitleColor(.sparkDarkGray, for: .normal)
        failButton.setTitleColor(.sparkDarkPinkred, for: .selected)
        failButton.setTitleColor(.sparkDarkPinkred, for: .highlighted)
        
        failLabel.text = "1"
        failLabel.font = .h3Subtitle
        failLabel.textColor = .sparkDarkGray
        failLabel.font = .enMediumFont(ofSize: 14)
        
        upperLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(21)
            make.leading.equalTo(doingButton)
        }
        
        lowerLabel.snp.makeConstraints { make in
            make.top.equalTo(upperLabel.snp.bottom).offset(4)
            make.leading.equalTo(doingButton)
        }
        
        doingButton.snp.makeConstraints { make in
            make.top.equalTo(lowerLabel.snp.bottom).offset(23)
            make.leading.equalTo(DoingCV).offset(23)
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
        
        DoingCV.snp.makeConstraints { make in
            make.top.equalTo(failButton.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-11)
        }
        
        DoneCV.snp.makeConstraints { make in
            make.top.equalTo(failButton.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-11)
        }
        
        FailCV.snp.makeConstraints { make in
            make.top.equalTo(failButton.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-11)
        }
    }

    // MARK: 버튼 기능 설정
    func addTargets(_ buttons: MyButton...) {
        for button in buttons {
            button.addTarget(self, action: #selector(changeCollectionView), for: .touchUpInside)
        }
    }
    
    // TODO: foreach 사용하기
    @objc func changeCollectionView(sender: MyButton) {
        let status: Int = (sender.statusCV)!
        switch status {
        case 1:
            DoingCV.isHidden = true
            DoneCV.isHidden = false
            FailCV.isHidden = true
            doingButton.isSelected = false
            doneButton.isSelected = true
            failButton.isSelected = false
            doingLabel.textColor = .sparkDarkGray
            doneLabel.textColor = .sparkDarkPinkred
            failLabel.textColor = .sparkDarkGray
        case 2:
            DoingCV.isHidden = true
            DoneCV.isHidden = true
            FailCV.isHidden = false
            doingButton.isSelected = false
            doneButton.isSelected = false
            failButton.isSelected = true
            doingLabel.textColor = .sparkDarkGray
            doneLabel.textColor = .sparkDarkGray
            failLabel.textColor = .sparkDarkPinkred
        default:
            DoingCV.isHidden = false
            DoneCV.isHidden = true
            FailCV.isHidden = true
            doingButton.isSelected = true
            doneButton.isSelected = false
            failButton.isSelected = false
            doingLabel.textColor = .sparkDarkPinkred
            doneLabel.textColor = .sparkDarkGray
            failLabel.textColor = .sparkDarkGray
        }
    }
}

extension StorageVC {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.view.addSubview(view)
        }
    }
    
    func setCarousels() {
        setCarouselLayout(collectionView: DoingCV)
        setCarouselLayout(collectionView: DoneCV)
        setCarouselLayout(collectionView: FailCV)
    }
    
    // TODO: 하나 레이아웃 다 잡고 레지스터 부분 밖으로 빼주자
    // 컬렉션뷰의 레이아웃을 캐러셀 형식으로 변환시키는 함수
    func setCarouselLayout(collectionView: UICollectionView) {
        let layout = CarouselLayout()
        
        let centerItemWidthScale: CGFloat = 327/375
        let centerItemHeightScale: CGFloat = 0.95
        
        layout.itemSize = CGSize(width: collectionView.frame.width*centerItemWidthScale, height: collectionView.frame.height*centerItemHeightScale)

        layout.sideItemScale = 464/520
        layout.spacing = 12
        layout.sideItemAlpha = 0.4
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
}

extension StorageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellCase = collectionView
        switch cellCase {
        case DoingCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoingStorageCVC", for: indexPath) as! DoingStorageCVC
            
            return cell
        case DoneCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoneStorageCVC", for: indexPath) as! DoneStorageCVC
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FailStorageCVC", for: indexPath) as! FailStorageCVC
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextSB = UIStoryboard.init(name: "StorageMore", bundle:nil)
        
        guard let nextVC = nextSB.instantiateViewController(identifier: "StorageMoreVC") as? StorageMoreVC else {return}
        
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
