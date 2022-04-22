//
//  SingleResponseDialogueVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/04/23.
//

import UIKit

import SnapKit

@frozen
public enum SingleResponseDialogueType {
    case update
}

class SingleResponseDialogueVC: UIViewController {

    // MARK: - Properties
    
    var dialougeView = UIView()
    var guideLabelView = UIView()
    var guideLabel = UILabel()
    var separatorView = UIView()
    var button = UIButton()
    var textLabel = UILabel()
    
    var dialogueType: SingleResponseDialogueType?
    var clousure: (() -> Void)?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAddTargets()
        setLayout()
    }
}

// MARK: - Extension

extension SingleResponseDialogueVC {
    private func setUI() {
        self.view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        dialougeView.backgroundColor = .sparkWhite
        
        guideLabelView.backgroundColor = .sparkWhite
        
        guideLabel.font = .p1TitleLight
        guideLabel.textColor = .sparkDeepGray
        guideLabel.textAlignment = .center
        guideLabel.numberOfLines = 0
        
        separatorView.backgroundColor = .sparkLightGray
        
        textLabel.font = .p1Title
        textLabel.textColor = .sparkDarkPinkred
        
        switch dialogueType {
        case .update:
            guideLabel.text = """
            최신 버전의 Spark가 출시되었어요.
            업데이트 후 이용해 주세요!
            """
            textLabel.text = "업데이트하기"
            
        case .none:
            print("dialogueType을 지정해주세요")
        }
    }
    
    private func setAddTargets() {
        button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(giveAlpahOfTextLabel), for: .touchDown)
        button.addTarget(self, action: #selector(eraseAlpahOfTextLabel), for: .touchDragOutside)

    }
    
    // MARK: - @objc Methods
    
    @objc
    private func touchButton() {
        clousure?()
    }
    
    @objc
    private func giveAlpahOfTextLabel() {
        textLabel.alpha = 0.5
    }
    
    @objc
    private func eraseAlpahOfTextLabel() {
        textLabel.alpha = 1
    }
}

// MARK: - Layout

extension SingleResponseDialogueVC {
    private func setLayout() {
        self.view.addSubview(dialougeView)
        
        dialougeView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(144)
        }
        
        dialougeView.addSubviews([guideLabelView, guideLabel, separatorView, textLabel, button])
        
        guideLabelView.snp.makeConstraints {
            $0.top.left.right.equalTo(dialougeView)
            $0.height.equalTo(96)
        }
        
        guideLabel.snp.makeConstraints {
            $0.center.equalTo(guideLabelView)
        }
        
        separatorView.snp.makeConstraints {
            $0.left.right.equalTo(dialougeView)
            $0.top.equalTo(guideLabelView.snp.bottom)
            $0.height.equalTo(1)
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.left.right.bottom.equalTo(dialougeView)
            $0.height.equalTo(47)
        }
        
        textLabel.snp.makeConstraints {
            $0.center.equalTo(button)
        }
    }
}
