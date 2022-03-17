//
//  LifeDiminishDialogueVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/03/17.
//

import UIKit

import SnapKit

class LifeDiminishDialogueVC: UIViewController {

    // MARK: - Properties
    
    var diminishedLifeCount: Int?
    
    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .sparkWhite
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "sparkflakePattern")
        return iv
    }()
    
    private let illustImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "sparkflakePattern")
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sparkPinkred
        label.font = .enMediumItatlicFont(ofSize: 24.0)
        label.text = "Oops..."
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sparkDeepGray
        label.font = .p1TitleLight
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var button: UIButton = {
        let bt = UIButton()
        bt.setTitle("확인했어요", for: .normal)
        bt.setTitleColor(.sparkWhite, for: .normal)
        bt.titleLabel?.font = .btn1Default
        bt.backgroundColor = .sparkBlack
        return bt
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setAddTargets()
    }
}

// MARK: - Extensions

extension LifeDiminishDialogueVC {
    private func setUI() {
        self.view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        subtitleLabel.text = """
                             앗! 생명이 \(diminishedLifeCount ?? 0)개 줄었어요.
                             아직 기회는 있으니 계속 달려보자고요!
                             """
    }
    
    private func setAddTargets() {
        button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
    }
    
    private func setLayout() {
        view.addSubview(popUpView)
        
        popUpView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(popUpView.snp.width).multipliedBy(1.61)
        }
        
        popUpView.addSubviews([backgroundImageView, illustImageView, titleLabel, subtitleLabel, button])
        
        backgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(21)
        }
        
        illustImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(46)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(illustImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(28)
            $0.leading.trailing.equalToSuperview().inset(106)
            $0.height.equalTo(button.snp.width).multipliedBy(0.4)
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func touchButton() {
        self.dismiss(animated: true)
    }
}
