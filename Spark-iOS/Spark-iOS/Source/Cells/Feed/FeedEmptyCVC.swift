//
//  FeedEmptyCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/18.
//

import UIKit

class FeedEmptyCVC: UICollectionViewCell {
    static let identifier = "FeedEmptyCVC"
    
    // MARK: - Properties
    
    let emptyView = UIView()
    let emptyImageView = UIImageView()
    let emptyLabel = UILabel()
    
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
        self.backgroundColor = .white
        
        emptyLabel.text = "아직 올라온 인증이 없어요.\n습관방에서 첫 인증을 시작해 보세요!"
        emptyLabel.textAlignment = .center
        emptyLabel.font = .krRegularFont(ofSize: 18)
        emptyLabel.textColor = .sparkDarkGray
        emptyLabel.numberOfLines = 2
        
        emptyImageView.image = UIImage(named: "tagEmpty")
    }
    
    private func setLayout() {
        self.addSubviews([emptyView])
        
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyView.addSubviews([emptyLabel, emptyImageView])
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.width.equalTo(90)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
