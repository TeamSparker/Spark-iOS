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
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let name = UICollectionView(frame: CGRect(x: 0,y: 197,width: 375,height: 520), collectionViewLayout: layout)
        name.backgroundColor = .blue
        
        return name
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(storageMoreCV)
        setDelegate()
        registerXib()
    }
    
    func setDelegate() {
        storageMoreCV.delegate = self
        storageMoreCV.dataSource = self
    }
    
    func registerXib() {
        let xibCollectionViewName = UINib(nibName: "MoreStorageCVC", bundle: nil)
        storageMoreCV.register(xibCollectionViewName, forCellWithReuseIdentifier: "MoreStorageCVC")
    }

}

extension StorageMoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height:197)
    }
}

extension StorageMoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreStorageCVC", for: indexPath) as? MoreStorageCVC else {return UICollectionViewCell()}

        return cell
    }
}
