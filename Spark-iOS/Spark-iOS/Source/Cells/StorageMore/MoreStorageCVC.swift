//
//  MoreStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class MoreStorageCVC: UICollectionViewCell {

    @IBOutlet weak var dDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    func setUI() {
        dDayLabel.font = .p2Subtitle2Eng
        dDayLabel.textColor = .sparkGray
        dDayLabel.text = "D-day"
    }
}
