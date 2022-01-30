//
//  WaitingFriendCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//

import UIKit

import SnapKit

class WaitingFriendCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        profileImageView.image = UIImage()
    }
}

// MARK: - Methods

extension WaitingFriendCVC {
    private func setUI() {
        profileImageView.backgroundColor = .sparkGray
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = .p1Title
        nameLabel.textColor = .sparkDeepGray
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.textAlignment = .center
    }
    
    private func setLayout() {
        addSubviews([profileImageView, nameLabel])
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.centerX.equalTo(profileImageView.snp.centerX)
            make.width.equalTo(profileImageView.snp.width)
        }
    }
    
    /// 셀 초기화.
    func initCell(name: String, imagePath: String) {
        nameLabel.text = name
        profileImageView.updateImage(imagePath)
    }
}
