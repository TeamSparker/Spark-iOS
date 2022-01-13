//
//  StorageMoreVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class StorageMoreVC: UIViewController {
    
    var storageMoreCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let name = UICollectionView(frame: CGRect(x: 0,y: 120,width: 375,height: 520), collectionViewLayout: layout)
        name.backgroundColor = .clear
        
        return name
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(storageMoreCV)
        setDelegate()
        registerXib()
        setLayout()
    }
    
    func setDelegate() {
        storageMoreCV.delegate = self
        storageMoreCV.dataSource = self
    }
    
    func registerXib() {
        let xibCollectionViewName = UINib(nibName: "MoreStorageCVC", bundle: nil)
        storageMoreCV.register(xibCollectionViewName, forCellWithReuseIdentifier: "MoreStorageCVC")
    }
    
    func setLayout() {
        storageMoreCV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-50)
        }
        self.view.backgroundColor = .sparkBlack
    }

}

extension StorageMoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 컬렉션뷰 크기 정하기
        // 컬렉션뷰 위드에 맞게 셀 위드 정하기
        // 셀 위드에 대해서 간격과 높이 정하기
        let cellWidth: CGFloat = collectionView.frame.width
        let cellWidthRatio: CGFloat = 160/335
        let widthHeightRatio: CGFloat = 197/160
        let cell = CGSize(width: cellWidth*cellWidthRatio, height: cellWidth*cellWidthRatio*widthHeightRatio)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = collectionView.frame.width
        let cellWidthRatio: CGFloat = 160/335
        let newCellWidth = cellWidth*cellWidthRatio
        let spacingRatio: CGFloat = 15/160
        let totalCellWidth = newCellWidth * 2
        let totalSpacingWidth = spacingRatio*newCellWidth
        print(totalCellWidth)
        print(totalSpacingWidth)
        let leftInset = totalSpacingWidth/4
        print(leftInset)
        let rightInset = leftInset
        let A = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        print(A)
        return A
    }
}

extension StorageMoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreStorageCVC", for: indexPath) as? MoreStorageCVC else {return UICollectionViewCell()}

        return cell
    }
}
