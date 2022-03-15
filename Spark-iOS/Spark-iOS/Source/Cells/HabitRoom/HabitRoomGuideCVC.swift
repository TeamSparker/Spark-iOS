//
//  HabitRoomGuideCVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/16.
//

import UIKit

import SnapKit

class HabitRoomGuideCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let guideImageView = UIImageView()
    private let guideLabel = UILabel()
    
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
        
    }
    
    // MARK: - Methods
    
    private func setUI() {
        guideLabel.text = "습관방의 생명은 오직 3개,\n매일 자정까지 잊지 말고 인증하기!"
        guideLabel.textAlignment = .center
        guideLabel.font = .p1TitleLight
        guideLabel.textColor = .sparkDeepGray
        guideLabel.numberOfLines = 2
        
        guideImageView.backgroundColor = .darkGray
        guideImageView.contentMode = .scaleAspectFill
    }
    
    private func setLayout() {
        self.addSubviews([guideImageView, guideLabel])
        
        guideImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(242)
            make.height.equalTo(165)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(guideImageView.snp.bottom).offset(28)
            make.bottom.equalToSuperview()
        }
    }
}
