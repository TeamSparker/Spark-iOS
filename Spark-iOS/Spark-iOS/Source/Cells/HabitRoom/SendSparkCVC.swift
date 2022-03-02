//
//  SendSparkCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/03/02.
//

import UIKit

import SnapKit

class SendSparkCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    lazy var sparkButton = SendSparkButton(type: .message)
    {
        didSet {
            setUI()
            setLayout()
        }
    }

    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
    }
}

// MARK: - Methods

extension SendSparkCVC {
    func setSparkButton(type: SendSparkStatus) {
        self.sparkButton = SendSparkButton(type: type)
    }
    
    private func setUI() {

    }
    
    private func setLayout() {
        addSubviews([sparkButton])
        
        sparkButton.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    /// 셀 초기화.
    func initCell(name: String, imagePath: String) {
//        nameLabel.text = name
//        profileImageView.updateImage(imagePath)
    }
}
