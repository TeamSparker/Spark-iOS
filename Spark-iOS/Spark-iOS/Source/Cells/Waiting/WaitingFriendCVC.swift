//
//  WaitingFriendCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/13.
//

import UIKit

import SnapKit

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
    
    override func prepareForReuse() {
        nameLabel.text = ""
        profileImageView.backgroundColor = .sparkBrightPinkred
        profileImageView.layer.masksToBounds = true
    }
    
    // MARK: - Methods
    func setUI() {
        profileImageView.backgroundColor = .sparkBrightPinkred
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        
        nameLabel.font = .p1Title
        nameLabel.textColor = .sparkDeepGray
    }
    
    func setLayout() {
        addSubviews([profileImageView, nameLabel])
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.centerX.equalTo(profileImageView.snp.centerX)
        }
    }
    
    func initCell() {
        nameLabel.text = "이름"
        // 파라미터 추가 + 이미지 넣기
    }
}
