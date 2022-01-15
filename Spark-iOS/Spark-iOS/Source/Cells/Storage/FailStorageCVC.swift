//
//  FailStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class FailStorageCVC: UICollectionViewCell {
    @IBOutlet weak var gradationUIView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    func setUI() {
        gradationUIView.setGradient(color1: UIColor.clear, color2: UIColor.black)
    }
}
