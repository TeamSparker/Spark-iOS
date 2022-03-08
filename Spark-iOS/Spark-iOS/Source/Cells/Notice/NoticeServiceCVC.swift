//
//  NoticeServiceCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/08.
//

import UIKit

import SnapKit

class NoticeServiceCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let dateLabel = UILabel()
    
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
        contentLabel.text = ""
        dateLabel.text = ""
    }
    
    // MARK: - Methods
    
    private func setUI() {
        titleLabel.font = .p1Title
        contentLabel.font = .p2Subtitle
        dateLabel.font = .caption
        
        titleLabel.textColor = .sparkBlack
        contentLabel.textColor = .sparkDeepGray
        dateLabel.textColor = .sparkDarkGray
        
        titleLabel.numberOfLines = 2
        contentLabel.numberOfLines = 2
    }
    
    func initCell(title: String, content: String, date: String) {
        titleLabel.text = title
        contentLabel.text = content
        dateLabel.text = date
    }
}

// MARK: - Layout

extension NoticeServiceCVC {
    private func setLayout() {
        self.addSubviews([titleLabel, contentLabel, dateLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(22)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(70)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(22)
        }
    }
}
