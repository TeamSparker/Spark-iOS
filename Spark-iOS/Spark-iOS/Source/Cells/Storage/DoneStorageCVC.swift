//
//  DoneStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class DoneStorageCVC: UICollectionViewCell {
    @IBOutlet weak var gradationUIView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sparkCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI() {
        gradationUIView.setGradient(color1: UIColor.clear, color2: UIColor.black)
    }
    
    func initCell(roomName: String,
                  thumbnail: String,
                  sparkCount: Int,
                  startDate: String,
                  endDate: String) {
        sparkCountLabel.text = String(sparkCount)
        roomNameLabel.text = roomName
        
        let startDate = startDate.split(separator: "-")
        let endDate = endDate.split(separator: "-")
        dateLabel.text = "\(startDate[0]).\(startDate[1]).\(startDate[2]) - \(endDate[0]).\(endDate[1]).\(endDate[2])"
        
        thumbnailImage.updateImage(thumbnail)
    }
}
