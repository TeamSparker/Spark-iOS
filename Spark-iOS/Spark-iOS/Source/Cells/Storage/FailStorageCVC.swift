//
//  FailStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class FailStorageCVC: UICollectionViewCell {
    @IBOutlet weak var gradationUIView: UIView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var sparkCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    func setUI() {
        gradationUIView.setGradient(color1: UIColor.clear, color2: UIColor.black)
    }
}
