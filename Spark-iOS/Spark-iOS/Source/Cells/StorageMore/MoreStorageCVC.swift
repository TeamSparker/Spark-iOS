//
//  MoreStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

import SnapKit

class MoreStorageCVC: UICollectionViewCell {
    
    var isChangingImageView: Bool = false
    
    @IBOutlet weak var sparkCountLabel: UILabel!
    @IBOutlet weak var certificationImage: UIImageView!
    @IBOutlet weak var dDayOrPointLabel: UILabel!
    @IBOutlet weak var sparkStackView: UIStackView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerAlphaView: UIView!
    
    override var isSelected: Bool {
        didSet {
            if isChangingImageView {
                if isSelected {
                    certificationImage.layer.borderColor = UIColor.sparkPinkred.cgColor
                    dDayOrPointLabel.isHidden = false
                } else {
                    certificationImage.layer.borderColor = UIColor.sparkLightGray.cgColor
                    dDayOrPointLabel.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI() {
        dDayOrPointLabel.font = .p2Subtitle2Eng
        dDayOrPointLabel.textColor = .sparkGray
        
        certificationImage.layer.masksToBounds = true
        certificationImage.contentMode = .scaleAspectFill
        certificationImage.layer.borderColor = UIColor.sparkLightGray.cgColor
        certificationImage.layer.borderWidth = 1
        certificationImage.layer.cornerRadius = 2
        
        timerLabel.font = .enBoldFont(ofSize: 24)
        
        if isChangingImageView {
            [sparkStackView, timerLabel, timerAlphaView, dDayOrPointLabel].forEach {
                $0?.isHidden = true
            }
            
            dDayOrPointLabel.text = "대표"
            dDayOrPointLabel.font = .btn4Small
            dDayOrPointLabel.textColor = .sparkWhite
            dDayOrPointLabel.backgroundColor = .sparkPinkred
            dDayOrPointLabel.layer.cornerRadius = 2
            dDayOrPointLabel.clipsToBounds = true
            dDayOrPointLabel.textAlignment = .center
            
            dDayOrPointLabel.snp.makeConstraints { make in
                make.width.equalTo(42)
                make.height.equalTo(24)
            }
        }
    }
    
    override func prepareForReuse() {
        certificationImage.image = UIImage()
        dDayOrPointLabel.text = ""
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
            dDayOrPointLabel.text = "D-day"
        } else if leftDay == 66 {
            dDayOrPointLabel.text = "D-\(leftDay)"
            certificationImage.image = UIImage()
        } else {
            dDayOrPointLabel.text = "D-\(leftDay)"
        }
        
        if let timer = timerCount {
            timerAlphaView.isHidden = false
            timerLabel.text = timer
        }
    }
}
