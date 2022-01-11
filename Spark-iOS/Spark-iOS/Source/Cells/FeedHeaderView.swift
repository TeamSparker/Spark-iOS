//
//  FeedHeaderView.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/12.
//

import UIKit

import SwiftUI
import SnapKit

class FeedHeaderView: UICollectionReusableView {
    
    let dateLabel = UILabel()
    let dayLabel = UILabel()
       
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        dateLabel.font = .h3SubtitleEng
        dateLabel.text = "2022년 1월 7일"
        dateLabel.textColor = .sparkDeepGray
        
        dayLabel.font = .p1TitleLight
        dayLabel.text = "금요일"
        dayLabel.textColor = .sparkDarkGray
    }
    
    func setLayout() {
        self.addSubview(dateLabel)
        self.addSubview(dayLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(dateLabel.snp.bottom)
        }
    }
}
