//
//  FeedCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/12.
//

import UIKit

import SnapKit
import Lottie

class FeedCVC: UICollectionViewCell {
    static let identifier = "FeedCVC"
    
    // MARK: - Properties
    
    private let feedImageView = UIImageView()
    private let fadeImageView = UIImageView()
    private let timeLabel = UILabel()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let doneImageView = UIImageView()
    
    private let sparkStackView = UIStackView()
    private let sparkLabel = UILabel()
    private let sparkIconImageView = UIImageView()
    private let sparkCountLabel = UILabel()
    
    private let likeButton = UIButton()
    private let likeCountLabel = UILabel()
    private let lottieView = AnimationView(name: "icHeartActive")
    
    weak var likeDelegate: FeedCellDelegate?
    private var likeState: Bool = false
    private var cellId: Int = 0
    private var indexPath: IndexPath?
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setStackView()
        setLayout()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // FIXME: - 두개의 셀이 보일 때, 아래의 셀에서 하트를 누르면 위 셀의 하트 로티가 작동.. 로티는 어떻게 초기화 시켜주지...
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        nameLabel.text = ""
        sparkCountLabel.text = ""
        likeCountLabel.text = ""
        timeLabel.text = ""
        feedImageView.image = UIImage()
        fadeImageView.image = UIImage()
        profileImageView.image = UIImage()
        likeState = true
    }
    
    // MARK: - Methods
    func initCell(title: String, nickName: String, timeRecord: String?, likeCount: Int, sparkCount: Int, profileImg: String?, certifyingImg: String, hasTime: Bool, isLiked: Bool, recordId: Int, indexPath: IndexPath) {
        titleLabel.text = "\(title)"
        nameLabel.text = "\(nickName)"
        sparkCountLabel.text = "\(sparkCount)"
        likeCountLabel.text = "\(likeCount)"
        feedImageView.updateImage(certifyingImg)
        cellId = recordId
        
        if let profile = profileImg {
            profileImageView.updateImage(profile)
        } else {
            profileImageView.image = UIImage(named: "profileEmpty")
        }
        
        if let time = timeRecord {
            timeLabel.text = "\(time)"
        } else {
            timeLabel.text = ""
        }
        
        if isLiked {
            likeState = true
            likeButton.setImage(UIImage(named: "icHeartActive"), for: .normal)
            likeCountLabel.textColor = .sparkDarkPinkred
        } else {
            likeState = false
            likeButton.setImage(UIImage(named: "icHeartInactive"), for: .normal)
            likeCountLabel.textColor = .sparkGray
        }
        
        self.indexPath = indexPath
    }
    
    private func setAddTarget() {
        likeButton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
    }
    
    // FIXME: - 고쳐
    @objc
    func tapLikeButton() {
        let originLike = Int(likeCountLabel.text ?? "") ?? 0
        if !likeState {
            // like 눌리지 않음 -> 눌림
            setLikeLottie()
            
            likeButton.setImage(UIImage(named: "icHeartActive"), for: .normal)
            likeCountLabel.textColor = .sparkDarkPinkred
            likeCountLabel.text = "\(originLike + 1)"
            likeState = true
        } else {
            // like 눌림 -> 눌리지 않음
            if originLike > 0 {
                likeButton.setImage(UIImage(named: "icHeartInactive"), for: .normal)
                likeCountLabel.textColor = .sparkGray
                likeCountLabel.text = "\(originLike - 1)"
                likeState = false
            }
        }
        // likeState 가 false 라면 좋아요를 취소한 것.
        self.likeDelegate?.likeButtonTapped(recordID: cellId, indexPath: self.indexPath ?? IndexPath(item: 0, section: 0), likeState: !likeState)
    }
}

// MARK: - UI
extension FeedCVC {
    private func setUI() {
        self.backgroundColor = .white
        
        fadeImageView.backgroundColor = .sparkBlack.withAlphaComponent(0.15)
        
        profileImageView.backgroundColor = .sparkGray
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.cornerRadius = 32
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        feedImageView.contentMode = .scaleAspectFill
        feedImageView.layer.masksToBounds = true
        
        sparkLabel.text = "받은 스파크"
        
        timeLabel.font = .enBoldFont(ofSize: 40)
        nameLabel.font = .p1Title
        titleLabel.font = .krBoldFont(ofSize: 20)
        sparkCountLabel.font = .p2SubtitleEng
        likeCountLabel.font = .h2TitleEng
        
        timeLabel.textColor = .sparkWhite
        nameLabel.textColor = .sparkDeepGray
        titleLabel.textColor = .sparkDeepGray
        sparkLabel.textColor = .sparkDarkGray
        sparkCountLabel.textColor = .sparkDarkGray
        likeCountLabel.textColor = .sparkGray
        
        doneImageView.image = UIImage(named: "tagDone")
        sparkIconImageView.image = UIImage(named: "icFire")
        likeButton.setImage(UIImage(named: "icHeartInactive"), for: .normal)
    }
    
    private func setStackView() {
        titleStackView.axis = .horizontal
        titleStackView.alignment = .bottom
        titleStackView.distribution = .equalSpacing
        titleStackView.spacing = 8
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(doneImageView)
        
        sparkStackView.axis = .horizontal
        sparkStackView.alignment = .fill
        sparkStackView.distribution = .equalSpacing
        sparkStackView.spacing = 3
        sparkStackView.addArrangedSubview(sparkLabel)
        sparkStackView.addArrangedSubview(sparkIconImageView)
        sparkStackView.addArrangedSubview(sparkCountLabel)
    }
    
    private func setLikeLottie() {
        self.addSubview(lottieView)

        lottieView.snp.makeConstraints { make in
            make.center.equalTo(likeButton.snp.center)
            make.width.height.equalTo(40)
        }

        lottieView.center = likeButton.center
        lottieView.loopMode = .playOnce
        lottieView.contentMode = .scaleAspectFit
        lottieView.layer.masksToBounds = true
        lottieView.play {_ in
            print("되는거여?🤬")
            self.lottieView.stop()
            self.lottieView.removeFromSuperview()
        }
    }
}

// MARK: - Layout
extension FeedCVC {
    private func setLayout() {
        self.addSubviews([feedImageView, fadeImageView, profileImageView,
                          nameLabel, titleStackView, timeLabel,
                          sparkStackView, likeButton, likeCountLabel])
        
        feedImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(1.0 / 1.0)
        }
        
        fadeImageView.snp.makeConstraints { make in
            make.edges.equalTo(feedImageView.snp.edges)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.center.equalTo(feedImageView.snp.center)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(feedImageView.snp.bottom)
            make.width.height.equalTo(64)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.height.equalTo(26)
        }
        
        sparkStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleStackView.snp.bottom).offset(8)
        }
        
        sparkIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(feedImageView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(50)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(5)
            make.centerY.equalTo(likeButton.snp.centerY)
        }
    }
}
