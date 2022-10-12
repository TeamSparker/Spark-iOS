//
//  UpgradeFlakeCVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/10/08.
//

import UIKit

import SnapKit

class UpgradeFlakeCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let upgradeFlakeImageView = UIImageView()
    
    // MARK: - View Life Cycle
    
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
        
        upgradeFlakeImageView.image = UIImage()
    }
    
    // MARK: - Methods
    
    public func initCell(_ image: UIImage) {
        upgradeFlakeImageView.image = image
    }
    
    private func setUI() {
        upgradeFlakeImageView.contentMode = .scaleAspectFill
    }
    
    private func setLayout() {
        contentView.addSubview(upgradeFlakeImageView)
        
        upgradeFlakeImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(53)
            $0.height.equalTo(upgradeFlakeImageView.snp.width)
        }
    }
}
