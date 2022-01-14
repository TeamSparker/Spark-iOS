//
//  TimerAuthView.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/14.
//

import UIKit

class TimerAuthView: UIView {
    
    // MARK: - Properties
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let photoImageView = UIImageView()
    let stopwatchImageView = UIImageView()
    
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
    func setUI() {
        titleLabel.text = "시간 측정 후 사진으로 인증하기"
        titleLabel.font = .h3Subtitle
        
        subTitleLabel.text = "30분 책 읽기, 1시간 러닝처럼 진행 과정을\n인증하는 습관에 추천해요."
        subTitleLabel.textColor = .sparkDarkGray
        subTitleLabel.font = .p1TitleLight
        subTitleLabel.numberOfLines = 2
        
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 2
    }
    
    func setSelectedUI() {
        titleLabel.textColor = .sparkPinkred
        photoImageView.image = UIImage(named: "stickerPhotoDefault")
        stopwatchImageView.image = UIImage(named: "stickerStopwatchDefault")
        
        self.backgroundColor = .sparkPinkred.withAlphaComponent(0.05)
        self.layer.borderColor = UIColor.sparkPinkred.cgColor
    }
    
    func setDeselectedUI() {
        titleLabel.textColor = .sparkDeepGray
        photoImageView.image = UIImage(named: "stickerPhotoGrayscale")
        stopwatchImageView.image = UIImage(named: "stickerStopwatchGrayscale")
        
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.sparkLightGray.cgColor
    }
    
    func setLayout() {
        addSubviews([titleLabel, subTitleLabel, photoImageView, stopwatchImageView])
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(72)
        }
        
        stopwatchImageView.snp.makeConstraints { make in
            make.trailing.equalTo(photoImageView.snp.leading).offset(-8)
            make.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(72)
        }
    }
}
