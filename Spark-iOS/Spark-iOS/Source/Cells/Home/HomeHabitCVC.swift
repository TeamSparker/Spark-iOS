//
//  HomeHabitCVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/13.
//

import UIKit

class HomeHabitCVC: UICollectionViewCell {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var flakeImage: UIImageView!
    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var ddayTitleLabel: UILabel!
    @IBOutlet weak var ddaySubtitleLabel: UILabel!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var tagDoneImage: UIImageView!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var firstProfileImage: UIImageView!
    @IBOutlet weak var secondProfileImage: UIImageView!
    @IBOutlet weak var thirdProfileImage: UIImageView!
    @IBOutlet weak var fourthProfileImage: UIImageView!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var firstLifeImage: UIImageView!
    @IBOutlet weak var secondLifeImage: UIImageView!
    @IBOutlet weak var thirdLifeImage: UIImageView!
    
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
    
    override func prepareForReuse() {
        flakeImage.image = UIImage()
        ticketImage.image = UIImage()
        restLabel.text = ""
        ddayTitleLabel.text = ""
        ddaySubtitleLabel.text = ""
        
        
        habitTitleLabel.text = ""
        tagDoneImage.isHidden = true
        memberLabel.text = ""
        firstLifeImage.image = UIImage()
        secondLifeImage.image = UIImage()
        thirdLifeImage.image = UIImage()
    }
}

// MARK: - Methods

extension HomeHabitCVC {
    private func setUI() {
        flakeImage.contentMode = .scaleAspectFill
        ticketImage.contentMode = .scaleAspectFit
        
        ddayTitleLabel.font = .h1Bigtitle
        ddaySubtitleLabel.font = .caption
        
        habitTitleLabel.font = .h2Title
        
        tagDoneImage.isHidden = true
    }
    
    private func setFlake(day: Int) {
        // TODO: - D-day 에 따라서 분기 처리(결정배경, 멘트 텍스트&색, 디데이텍스트%색)
    }
    
    func initCell() {
        // TODO: - 셀 초기화
    }
}
