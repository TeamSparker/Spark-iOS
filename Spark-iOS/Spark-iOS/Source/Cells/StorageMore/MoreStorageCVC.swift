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
        certificationImage.layer.masksToBounds = true
        certificationImage.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        certificationImage.image = UIImage()
        dDayLabel.text = ""
        sparkCountLabel.text = ""
    }
    
    func initCell(leftDay: Int,
                  mainImage: String,
                  sparkCount: Int,
                  status: String) {
        switch status {
        case "DONE":
            certificationImage.updateImage(mainImage)
        case "REST":
            certificationImage.image = UIImage(named: "stickerRestBigMybox")
        default:
            certificationImage.image = UIImage(named: "tagEmptyBox")
        }
        
        sparkCountLabel.text = String(sparkCount)
        
        if leftDay == 0 {
            dDayLabel.text = "D-day"
        } else if leftDay == 66 {
            dDayLabel.text = "D-\(leftDay)"
            certificationImage.image = UIImage()
        } else {
            dDayLabel.text = "D-\(leftDay)"
        }
    }
}
