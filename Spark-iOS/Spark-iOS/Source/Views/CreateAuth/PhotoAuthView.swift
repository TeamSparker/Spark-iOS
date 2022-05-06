//
//  PhotoAuthView.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/14.
//

import UIKit

import SnapKit

class PhotoAuthView: UIView {
    
    // MARK: - Properties
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let photoImageView = UIImageView()
    
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
        titleLabel.text = "사진으로 인증하기"
        titleLabel.font = .h3Subtitle
        
        subTitleLabel.text = "미라클 모닝, 영양제 먹기처럼 특정 순간을 \n인증하는 습관에 추천해요."
        subTitleLabel.textColor = .sparkDarkGray
        subTitleLabel.font = .p1TitleLight
        subTitleLabel.numberOfLines = 2
        
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 2
    }
    
    /// 선택된 경우 UI
    func setSelectedUI() {
        titleLabel.textColor = .sparkPinkred
        photoImageView.image = UIImage(named: "stickerPhotoDefault")
        
        self.backgroundColor = .sparkPinkred.withAlphaComponent(0.05)
        self.layer.borderColor = UIColor.sparkPinkred.cgColor
    }
    
    /// 선택 해제된 경우 UI
    func setDeselectedUI() {
        titleLabel.textColor = .sparkDeepGray
        photoImageView.image = UIImage(named: "stickerPhotoGrayscale")
        
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.sparkLightGray.cgColor
    }
    
    func setLayout() {
        addSubviews([titleLabel, subTitleLabel, photoImageView])
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(UIScreen.main.hasNotch ? 20 : 18)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 16 : 8)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(UIScreen.main.hasNotch ? 16 : 14)
            make.width.height.equalTo(UIScreen.main.hasNotch ? 72 : 60)
        }
    }
}
