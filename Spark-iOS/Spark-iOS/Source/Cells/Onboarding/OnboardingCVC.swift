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
        iv.backgroundColor = .sparkGray
        return iv
    }()
    
    lazy var sparkStartButton: BottomButton = {
        let bt = BottomButton()
        bt.setUI(.pink)
            .setTitle("스파크 시작하기")
        bt.isHidden = true
        return bt
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
    }
    
    private func setLayout() {
        self.addSubviews([guideLabel, illustImageView, sparkStartButton])
        
        guideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(144)
        }
        
        illustImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(37)
            make.top.equalTo(guideLabel.snp.bottom).offset(60)
        }
        
        sparkStartButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
}
