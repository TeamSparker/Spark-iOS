//
//  DialogueVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/18.
//

import UIKit

import SnapKit

@frozen
enum DialogueType {
    case exitSignUp
    case exitAuth
    case resetTimer
    case exitTimer
    case rest
    case deleteWaitingRoom
    case leaveWaitingRoom
    case createRoom
}

class DialogueVC: UIViewController {

    // MARK: Properties
    
    var dialogueType: DialogueType?
    var clousure: (() -> Void)?
    
    // MARK: IBoutlet Properties
    
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var resetOrExitLabel: UILabel!
    @IBOutlet weak var dialogueView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetOrExitButton: UIButton!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var resetOrExitView: UIView!
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAddTargets()
    }
    
}

// MARK: Methods
extension DialogueVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        dialogueView.layer.cornerRadius = 2
        
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
        
        case .deleteWaitingRoom:
            guideLabel.text = """
            정말 대기방을 삭제할 건가요?
            다른 스파커들에게도 습관방이 삭제돼요.
            """
            resetOrExitLabel.text = "삭제"
            
        case .leaveWaitingRoom:
            guideLabel.text = """
            정말 대기방을 나갈 건가요?
            습관이 시작되면 재접속이 불가능해요.
            """
            
        case .rest:
            guideLabel.text = """
            엇! 정말 쉴 건가요?
            푹 쉴 수 있도록 인증은 막아둘게요😊
            """
            resetOrExitLabel.text = "쉴래요"
            
        case .createRoom:
            guideLabel.text = """
            우왓👍! 이대로 습관방을 만들까요?
            방 이름과 인증 방식은 더이상 수정이 안 돼요.
            """
            resetOrExitLabel.text = "만들래요"
            resetOrExitLabel.textColor = .sparkDarkPinkred
            
        case .none:
            print("dialogueType을 지정해주세요")
        }
    }
    
    private func setAddTargets() {
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(giveAlphaCancelViewColor), for: .touchDown)
        cancelButton.addTarget(self, action: #selector(eraseAlphaCancelViewColor), for: .touchDragOutside)
        resetOrExitButton.addTarget(self, action: #selector(resetOrExitAction), for: .touchUpInside)
        resetOrExitButton.addTarget(self, action: #selector(giveAlphaResetOrExitViewColor), for: .touchDown)
        resetOrExitButton.addTarget(self, action: #selector(eraseAlphaResetOrExitViewColor), for: .touchDragOutside)
    }
    
    // MARK: objc methods
    
    @objc
    private func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 나가기 또는 초기화 액션을 넣어주세요
    @objc
    private func resetOrExitAction() {
        dismiss(animated: true) {
            self.clousure?()
        }
    }
    
    @objc
    private func giveAlphaCancelViewColor() {
        cancelView.alpha = 0.5
    }
    
    @objc
    private func eraseAlphaCancelViewColor() {
        cancelView.alpha = 1
    }
    
    @objc
    private func giveAlphaResetOrExitViewColor() {
        resetOrExitView.alpha = 0.5
    }
    
    @objc
    private func eraseAlphaResetOrExitViewColor() {
        resetOrExitView.alpha = 1
    }
}
