//
//  LifeTimeLineHeaderView.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/10/04.
//

import UIKit

import SnapKit

class LifeTimeLineHeaderView: UICollectionReusableView {
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    
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
    
    func setUI() {
        self.backgroundColor = .sparkWhite
        
        titleLabel.text = "생명 타임라인"
        titleLabel.font = .h3Subtitle
        titleLabel.textAlignment = .center
    }
    
    func setLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
        }
    }
}
