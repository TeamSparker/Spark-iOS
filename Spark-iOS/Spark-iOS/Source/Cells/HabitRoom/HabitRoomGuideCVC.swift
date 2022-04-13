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
    
    func initCell(image: String) {
        guideImageView.image = UIImage(named: image)
    }
    
    private func setUI() {        
        guideImageView.contentMode = .scaleAspectFill
    }
    
    private func setLayout() {
        self.addSubview(guideImageView)
        
        guideImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(242)
            make.height.equalTo(165)
        }
    }
}
