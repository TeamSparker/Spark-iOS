//
//  NoticeUpdateHeaderView.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/06.
//

import UIKit

import SnapKit

class NoticeUpdateHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let describeLabel = UILabel()
    private let dateLabel = UILabel()
    
    private var titleStr: String = "서비스 업데이트"
    private var describeStr: String = "‘스파크 보내기’ 업데이트ㅣ이제 내가 보내고 싶은 내용을 담아 스파크를 보낼 수 있게 되었어요!"
    private var dateStr: String = "2022. 01. 12"
        
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setLayout()
        setData(title: titleStr, describe: describeStr, date: dateStr)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.backgroundColor = .sparkLightGray
        
        titleLabel.font = .p1Title
        describeLabel.font = .p2Subtitle
        dateLabel.font = .caption
        
        titleLabel.textColor = .sparkBlack
        describeLabel.textColor = .sparkDeepGray
        dateLabel.textColor = .sparkDarkGray
        
        describeLabel.numberOfLines = 2
    }
    
    func setData(title: String, describe: String, date: String) {
        titleLabel.text = title
        describeLabel.text = describe
        dateLabel.text = date
    }
}

// MARK: - Layout

extension NoticeUpdateHeaderView {
    private func setLayout() {
        self.addSubviews([titleLabel, describeLabel, dateLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(22)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
        }
        
        describeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(22)
        }
    }
}
