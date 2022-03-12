//
//  OnboardingCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/03/12.
//

import UIKit

import SnapKit

class OnboardingCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: OnboardingCVCViewModel? {
        didSet { setUI() }
    }
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .h2Title
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let illustImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        guard let viewModel = viewModel else { return }
        
        guideLabel.attributedText = viewModel.guideText
        illustImageView.image = viewModel.illustImage
    }
    
    private func setLayout() {
        self.addSubviews([guideLabel, illustImageView])
        
        guideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(191)
        }
        
        illustImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(37)
            make.top.equalTo(guideLabel.snp.bottom).offset(83)
            make.height.equalTo(illustImageView.snp.width)
        }
    }
    
}
