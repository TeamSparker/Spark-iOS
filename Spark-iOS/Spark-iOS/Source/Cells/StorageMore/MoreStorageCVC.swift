//
//  MoreStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

import SnapKit

class MoreStorageCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    var isChangingImageView: Bool = false {
        didSet {
            setUI()
            setLayout()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isChangingImageView {
                if self.isSelected {
                    self.certificationImage.layer.borderColor = UIColor.sparkPinkred.cgColor
                    self.dDayOrPointLabel.isHidden = false
                } else {
                    self.certificationImage.layer.borderColor = UIColor.sparkLightGray.cgColor
                    self.dDayOrPointLabel.isHidden = true
                }
            }
        }
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var sparkCountLabel: UILabel!
    @IBOutlet weak var certificationImage: UIImageView!
    @IBOutlet weak var dDayOrPointLabel: UILabel!
    @IBOutlet weak var sparkStackView: UIStackView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerAlphaView: UIView!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    override func prepareForReuse() {
        certificationImage.image = UIImage()
        dDayOrPointLabel.text = ""
        sparkCountLabel.text = ""
        timerLabel.text = ""
    }
    
    // MARK: - Methods
    
    func initCell(leftDay: Int,
                  mainImage: String,
                  sparkCount: Int,
                  status: String,
                  timerCount: String?) {
        switch status {
        case "DONE":
            certificationImage.updateImage(mainImage, placeholder: .sparkDarkGray)
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
    
    func updateImage(mainImage: String,
                     status: String) {
        switch status {
        case "DONE":
            certificationImage.updateImage(mainImage, type: .small, placeholder: .sparkDarkGray)
            self.isUserInteractionEnabled = true
        case "REST":
            certificationImage.image = UIImage(named: "stickerRestBigMybox")
            self.isUserInteractionEnabled = false
        default:
            certificationImage.image = UIImage(named: "tagEmptyBox")
            self.isUserInteractionEnabled = false
        }
    }
}

// MARK: - UI & Layout

extension MoreStorageCVC {
    
    private func setUI() {
        dDayOrPointLabel.font = .p2Subtitle2Eng
        dDayOrPointLabel.textColor = .sparkGray
        
        certificationImage.layer.masksToBounds = true
        certificationImage.contentMode = .scaleAspectFill
        certificationImage.layer.cornerRadius = 2
        
        timerLabel.font = .enBoldFont(ofSize: 24)
        timerAlphaView.isHidden = true
        
        if isChangingImageView {
            [sparkStackView, timerLabel, timerAlphaView, dDayOrPointLabel].forEach {
                $0?.isHidden = true
            }
            
            certificationImage.layer.borderColor = UIColor.sparkLightGray.cgColor
            certificationImage.layer.borderWidth = 1
            
            dDayOrPointLabel.text = "대표"
            dDayOrPointLabel.font = .btn4Small
            dDayOrPointLabel.textColor = .sparkWhite
            dDayOrPointLabel.backgroundColor = .sparkPinkred
            dDayOrPointLabel.layer.cornerRadius = 2
            dDayOrPointLabel.clipsToBounds = true
            dDayOrPointLabel.textAlignment = .center
        }
    }
    
    private func setLayout() {
        dDayOrPointLabel.snp.makeConstraints { make in
            make.width.equalTo(42)
            make.height.equalTo(24)
        }
    }
}
