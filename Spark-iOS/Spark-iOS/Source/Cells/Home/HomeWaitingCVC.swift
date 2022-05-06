//
//  HomeWaitingCVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/13.
//

import UIKit

class HomeWaitingCVC: UICollectionViewCell {

    @IBOutlet weak var flakeImage: UIImageView!
    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var habitTitleLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setUI()
    }
    
    override func prepareForReuse() {
        habitTitleLabel.text = ""
        flakeImage.image = UIImage()
        ticketImage.image = UIImage()
    }
}

// MARK: - Methods

extension HomeWaitingCVC {
    private func setUI() {
        habitTitleLabel.font = .h2Title
        habitTitleLabel.textColor = .sparkDeepGray
    }
    
    func initCell(roomName: String) {
        habitTitleLabel.text = roomName
        
        flakeImage.image = UIImage(named: "property1TicketLeftWaitingroomHalf4")
        ticketImage.image = UIImage(named: "property1TicketRightWaitingroomHalf4")
    }
}
