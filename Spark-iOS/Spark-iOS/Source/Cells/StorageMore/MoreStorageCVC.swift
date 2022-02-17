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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerAlphaView: UIView!
    
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
        timerLabel.font = .enBoldFont(ofSize: 24)
        timerAlphaView.isHidden = true
    }
    
    override func prepareForReuse() {
        certificationImage.image = UIImage()
        dDayLabel.text = ""
        sparkCountLabel.text = ""
        timerLabel.text = ""
    }
    
    func initCell(leftDay: Int,
                  mainImage: String,
                  sparkCount: Int,
                  status: String,
                  timerCount: String?) {
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
        
        if let timer = timerCount {
            timerAlphaView.isHidden = false
            timerLabel.text = timer
        }
    }
}
