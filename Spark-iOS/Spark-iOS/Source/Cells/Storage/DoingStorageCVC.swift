//
//  DoingStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class DoingStorageCVC: UICollectionViewCell {
    
    @IBOutlet weak var gradationUIView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUIView()
    }

    func setUIView() {
        gradationUIView.setGradient(color1: UIColor.clear, color2: UIColor.black)
    }
}
