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
    }
    
    // MARK: - Custom Methods
    
    func initCell() {
        
    }
    
    private func setUI() {
        titleLabel.text = "zzzzz"
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
