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
    // MARK: - @objc Methods
    
    @objc
    private func touchButton() {
        self.dismiss(animated: true)
    }
}
