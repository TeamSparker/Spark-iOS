//
//  WaitingFriendCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//

import UIKit

class WaitingFriendCVC: UICollectionViewCell {
    static let identifier = "WaitingFriendCVC"
    
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
    
    // MARK: - Methods
    func setUI() {
        profileImageView.backgroundColor = .sparkBrightPinkred
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.cornerRadius = 32
        
        nameLabel.text = "수슈슉"
        nameLabel.font = .p1Title
        nameLabel.textColor = .sparkDeepGray
    }
    
    func setLayout() {
        addSubviews([profileImageView, nameLabel])
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.profileImageView.snp.width).multipliedBy(1.0/1.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.centerX.equalTo(profileImageView.snp.centerX)
        }
    }
}
