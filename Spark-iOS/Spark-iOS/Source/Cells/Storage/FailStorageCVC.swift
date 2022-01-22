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
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var flakeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    func setUI() {
        gradationUIView.setGradient(color1: UIColor.clear, color2: UIColor.black)
        thumbnailImage.contentMode = .scaleAspectFill
        thumbnailImage.layer.masksToBounds = true
    }
    
    func initCell(roomName: String,
                  leftDay: Int,
                  thumbnail: String,
                  sparkCount: Int,
                  startDate: String,
                  endDate: String) {
        let sparkFlake: SparkFlake = SparkFlake(leftDay: leftDay)
        
        flakeImage.image = sparkFlake.sparkFlakeFailStorage()
        sparkCountLabel.text = String(sparkCount)
        roomNameLabel.text = roomName
        
        let startDate = startDate.split(separator: "-")
        let endDate = endDate.split(separator: "-")
        dateLabel.text = "\(startDate[0]).\(startDate[1]).\(startDate[2]) - \(endDate[0]).\(endDate[1]).\(endDate[2])"
        
        dDayLabel.text = "\(leftDay) DAYS"
        
        thumbnailImage.updateImage(thumbnail)
    }
}
