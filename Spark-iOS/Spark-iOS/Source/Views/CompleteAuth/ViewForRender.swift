//
//  ViewForRender.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/21.
//
import UIKit

import SnapKit

class ViewForRender: UIView {
    
    // MARK: - Properties
    let roomNameLabel = UILabel()
    let nickNameLabel = UILabel()
    let profileImageView = UIImageView()
    let authImageView = UIImageView()
    let stickerImageView = UIImageView()
    let timerLabel = UILabel()
    let largeView = UIView()
    
    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    /// 기본 UI
    func setUI() {
        
        self.backgroundColor = .clear
        self.isOpaque = true
        
        largeView.backgroundColor = .sparkWhite
        largeView.layer.cornerRadius = 2
        
        stickerImageView.image = UIImage(named: "stickerCompleteDefault")
        
        authImageView.contentMode = .scaleAspectFill
        authImageView.layer.masksToBounds = true
        
        timerLabel.text = " "
        timerLabel.font = .enBoldFont(ofSize: 40)
        timerLabel.textColor = .sparkWhite
                
        nickNameLabel.text = " "
        roomNameLabel.font = .enBoldFont(ofSize: 16)
        nickNameLabel.textColor = .sparkDeepGray
        nickNameLabel.font = .p1Title
        
        roomNameLabel.text = " "
        roomNameLabel.font = .enBoldFont(ofSize: 20)
        roomNameLabel.textColor = .sparkDeepGray
        
        profileImageView.image = UIImage(named: "stickerPhotoDefault")
        profileImageView.layer.cornerRadius = 32
        profileImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        
        self.layer.cornerRadius = 2
    }
    
    func setLayout() {
        addSubviews([largeView, stickerImageView])
        
        largeView.addSubviews([authImageView, timerLabel, profileImageView,
                     nickNameLabel, roomNameLabel])
        
        largeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(38)
        }
        
        stickerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(96)
        }
        
        authImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.width.height.equalTo(312)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(authImageView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
            make.centerY.equalTo(authImageView.snp.bottom)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
        }
        
        roomNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nickNameLabel.snp.bottom).offset(13)
        }
    }
}
