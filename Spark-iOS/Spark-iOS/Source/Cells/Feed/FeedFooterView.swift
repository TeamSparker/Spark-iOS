//
//  FeedFooterView.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/02/02.
//

import UIKit

import SnapKit

class FeedFooterView: UICollectionReusableView {
        
    // MARK: - Properties
    let footerLabel = UILabel()
    
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
    
    private func setUI() {
        self.backgroundColor = .sparkWhite
        footerLabel.text = "최근 일주일 간의 인증만 보여집니다⚡️"
        footerLabel.textColor = .sparkGray
        footerLabel.font = .krRegularFont(ofSize: 16)
    }
    
    private func setLayout() {
        self.addSubview(footerLabel)
        
        footerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
