//
//  LifeTimeLineCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/10/04.
//

import UIKit

import SnapKit

class LifeTimeLineCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let firstProfileImageView = UIImageView()
    private let secondProfileImageView = UIImageView()
    private let dayLabel = UILabel()
    private let divideLine = UIView()
    
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
        super.prepareForReuse()
        titleLabel.text = ""
        subTitleLabel.text = ""
        dayLabel.text = ""
        firstProfileImageView.image = UIImage()
        secondProfileImageView.image = UIImage()
        firstProfileImageView.isHidden = true
        secondProfileImageView.isHidden = true
    }
    
    // MARK: - Custom Methods
    
    func initCell(title: String,
                  subTitle: String,
                  profilImg: [String],
                  day: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        dayLabel.text = day
        
        if !profilImg.isEmpty {
            updateProfileLayout()
            let profileImageList = [firstProfileImageView, secondProfileImageView]
            for index in 0..<profilImg.count {
                profileImageList[index].updateImage(profilImg[index] , type: .small)
                profileImageList[index].isHidden = false
            }
        } else {
            updateDayLayout()
        }
    }
    
    private func setUI() {
        titleLabel.font = .p1Title
        subTitleLabel.font = .p2Subtitle
        dayLabel.font = .caption
        
        titleLabel.textColor = .sparkBlack
        subTitleLabel.textColor = .sparkDeepGray
        dayLabel.textColor = .sparkDarkGray
        
        [firstProfileImageView, secondProfileImageView].forEach {
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.sparkWhite.cgColor
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.isHidden = true
        }
        
        divideLine.backgroundColor = .sparkLightGray
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel, subTitleLabel,
                          dayLabel, divideLine])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        divideLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func updateDayLayout() {
        dayLabel.snp.remakeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func updateProfileLayout() {
        self.addSubviews([firstProfileImageView, secondProfileImageView])
        
        firstProfileImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.height.equalTo(28)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(8)
        }
        
        secondProfileImageView.snp.makeConstraints { make in
            make.leading.equalTo(firstProfileImageView.snp.trailing).offset(-9)
            make.centerY.equalTo(firstProfileImageView.snp.centerY)
            make.width.height.equalTo(28)
        }
        
        dayLabel.snp.remakeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(firstProfileImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
