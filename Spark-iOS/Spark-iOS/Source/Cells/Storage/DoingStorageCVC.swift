//
//  DoingStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class DoingStorageCVC: UICollectionViewCell {
    
    @IBOutlet weak var gradationUIView: UIView!
    @IBOutlet weak var cardBorderImageView: UIImageView!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var flakeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    func setUI() {
        gradationUIView.setGradient(color1: UIColor.clear, color2: UIColor.black)
    }
    
    func initCell(roomName: String,
                  leftDay: Int,
                  thumbnail: String,
                  sparkCount: Int,
                  startDate: String,
                  endDate: String) {
        let sparkFlake: SparkFlake = SparkFlake(leftDay: leftDay)
        
        if leftDay == 0 {
            dDayLabel.text = "D-day"
        } else {
            dDayLabel.text = "D-\(leftDay)"
        }
    }
}
