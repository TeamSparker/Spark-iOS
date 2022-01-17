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
        restLabel.isHidden = true
        ddayTitleLabel.text = ""
        ddaySubtitleLabel.text = ""
        fourthProfileImage.isHidden = true
        
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
        
        [firstProfileImage, secondProfileImage, thirdProfileImage, fourthProfileImage].forEach {
            $0?.layer.cornerRadius = 13
            $0?.layer.borderWidth = 2
            $0?.layer.borderColor = UIColor.sparkWhite.cgColor
        }
        
        restLabel.font = .enMediumFont(ofSize: 10)
        restLabel.textColor = .sparkWhite
        
        habitTitleLabel.font = .h2Title
        habitTitleLabel.textColor = .sparkDeepGray
        habitTitleLabel.numberOfLines = 2
        habitTitleLabel.lineBreakMode = .byTruncatingTail
        
        tagDoneImage.isHidden = true
        
        memberLabel.textColor = .sparkDeepGray
    }
    
    private func setFlake(day: Int) {
        // TODO: - D-day 에 따라서 분기 처리(결정배경, 멘트 텍스트&색, 디데이텍스트색)
        //        ddayTitleLabel.textColor
//        ddaySubtitleLabel.text
//        ddaySubtitleLabel.textColor
//        flakeImage.image
//        let attributedString = NSMutableAttributedString(string: "\(doneMemberNum)/\(memberNum)명")
//        attributedString.addAttribute(.foregroundColor, value: UIColor.sparkMostLightPinkred, range: NSRange(location: 0, length: "\(doneMemberNum)".count))
//        memberLabel.attributedText = attributedString
    }
    
    func initCell(roomName: String,
                  leftDay: Int,
                  profileImg: [String?],
                  life: Int,
                  isDone: Bool,
                  memberNum: Int,
                  doneMemberNum: Int) {
        ddayTitleLabel.text = "\(leftDay)"
        
        // TODO: - 프로필 이미지 구현
        if profileImg.count > 3 {
            fourthProfileImage.isHidden = false
            restLabel.isHidden = false
            restLabel.text = "+\(profileImg.count - 3)"
        } else {
            fourthProfileImage.isHidden = true
            restLabel.isHidden = true
        }
        
        habitTitleLabel.text = roomName
        
        // TODO: - 목숨 이미지 구현
        
        if isDone {
            ticketImage.image = UIImage(named: "property1TicketRightFold4")
        } else {
            ticketImage.image = UIImage(named: "property1TicketRight4")
        }
    }
}
