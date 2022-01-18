//
//  DialogueVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/18.
//

import UIKit

import SnapKit

@frozen enum DialogueType {
    case exitSignUp
    case exitAuth
    case resetTimer
    case exitTimer
}

class DialogueVC: UIViewController {

    // MARK: Properties
    
    var dialogueType: DialogueType?
    
    // MARK: IBoutlet Properties
    
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var resetOrExitLabel: UILabel!
    @IBOutlet weak var dialogueVIew: UIView!
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
}

// MARK: Methods
extension DialogueVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        dialogueVIew.layer.cornerRadius = 2
        
        dialogueType = .exitTimer
        
        guideLabel.font = .p1TitleLight
        cancelLabel.font = .btn3
        resetOrExitLabel.font = .btn3
        resetOrExitLabel.textColor = .sparkDarkPinkred
        
        switch dialogueType {
            
        case .exitSignUp:
            guideLabel.text = """
            회원가입이 완료되지 않았습니다.
            그래도 나가시겠습니까?
            """
            
        case .exitAuth:
            guideLabel.text = """
            인증이 완료되지 않았습니다.
            그래도 나가시겠습니까?
            """
            
        case .resetTimer:
            guideLabel.text = "스톱워치를 초기화하시겠습니까?"
            resetOrExitLabel.text = "초기화"
            
        case .exitTimer:
            guideLabel.text = """
            이미 측정한 시간 기록이 사라집니다.
            그래도 나가시겠습니까?
            """
            
        case .none:
            print("dialogueType을 지정해주세요")
            
        }
    }
}
