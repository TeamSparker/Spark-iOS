//
//  NoticeActiveCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/08.
//

import UIKit

class NoticeActiveCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentImageView = UIImageView()
    
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
        titleLabel.text = ""
        contentLabel.text = ""
        dateLabel.text = ""
        contentImageView.image = UIImage()
    }
    
    // MARK: - Method
    
    private func setUI() {
        titleLabel.font = .p1Title
        contentLabel.font = .p2Subtitle
        dateLabel.font = .caption
        
        titleLabel.textColor = .sparkBlack
        contentLabel.textColor = .sparkDeepGray
        dateLabel.textColor = .sparkDarkGray
        
        titleLabel.numberOfLines = 2
        contentLabel.numberOfLines = 2
        
        contentImageView.layer.borderWidth = 2
        contentImageView.layer.borderColor = UIColor.sparkWhite.cgColor
        contentImageView.layer.masksToBounds = true
        contentImageView.contentMode = .scaleAspectFill
    }
    
    func initCell(title: String, content: String, image: String) {
        titleLabel.text = title
        contentLabel.text = content
        contentImageView.updateImage(image, type: .small)
    }
}

// MARK: - Layout

extension NoticeActiveCVC {
    private func setLayout() {
        self.addSubviews([titleLabel, contentLabel, dateLabel, contentImageView])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(22)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(22)
        }
        
        contentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(44)
        }
    }
}
