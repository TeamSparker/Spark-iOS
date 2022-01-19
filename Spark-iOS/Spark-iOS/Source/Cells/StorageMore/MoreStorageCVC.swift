//
//  MoreStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class MoreStorageCVC: UICollectionViewCell {

    @IBOutlet weak var sparkCountLabel: UILabel!
    @IBOutlet weak var certificationImage: UIImageView!
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
    
    func initCell(leftDay: Int,
                  mainImage: String,
                  sparkCount: Int) {
        
        sparkCountLabel.text = String(sparkCount)
        
        if leftDay == 0 {
            dDayLabel.text = "D-day"
        } else {
            dDayLabel.text = "D-\(leftDay)"
        }
        
        certificationImage.updateImage(mainImage)
    }
}
