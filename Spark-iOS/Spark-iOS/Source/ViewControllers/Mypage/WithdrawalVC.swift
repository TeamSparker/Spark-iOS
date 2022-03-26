//
//  WithdrawalVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/25.
//

import UIKit

class WithdrawalVC: UIViewController {

    // MARK: - Properties
    
    private let customNavigationBar = LeftButtonNavigaitonBar()
    private let titleLabel = UILabel()
    private let topDividerLine = UIView()
    private let subtitleLabel = UILabel()
    private let firstCircleLabel = UILabel()
    private let firstTextView = UITextView()
    private let secondCircleLabel = UILabel()
    private let secondTextView = UITextView()
    private let bottomDividerLine = UIView()
    private let checkboxButton = UIButton()
    private let withdrawalLabel = UILabel()
    private let withdrawalButton = BottomButton()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setAddTargets()
    }
}

// MARK: - Extension

extension WithdrawalVC {
    private func setUI() {
        customNavigationBar.title("회원 탈퇴")
            .leftButtonImage("icBackWhite")
            .leftButtonAction {
                self.navigationController?.popViewController(animated: true)
            }
        
        titleLabel.font = .h3Subtitle
        titleLabel.textColor = .sparkBlack
        titleLabel.text = "회원 탈퇴 유의사항"
        
        topDividerLine.backgroundColor = .sparkDarkGray
        
        subtitleLabel.font = .p1TitleLight
        subtitleLabel.textColor = .sparkDarkGray
        subtitleLabel.text = "회원 탈퇴 시,"
        
        firstTextView.font = .p1TitleLight
        firstTextView.text = "진행 중인 모든 습관방에서 나가지며, 그동안의 습관 기록들은 전부 삭제되어 복구 불가능합니다."
        firstCircleLabel.font = .p1TitleLight
        firstCircleLabel.text = "  •  "
        firstCircleLabel.textColor = .sparkDarkGray
        
        secondTextView.font = .p1TitleLight
        secondTextView.text = " 최근 7일 동안의 습관 인증, 친구에게 보낸 스파크, 좋아요 등 타 스파커들에게 공유된 정보는 각가의 습관방에 귀속되어, 생성일로부터 7일 동안 보관 후 삭제됩니다."
        secondCircleLabel.font = .p1TitleLight
        secondCircleLabel.text = "  •  "
        secondCircleLabel.textColor = .sparkDarkGray
        
        bottomDividerLine.backgroundColor = .sparkDarkGray
        
        checkboxButton.setImage(UIImage(named: "btnCheckBoxDefault"), for: .normal)
        checkboxButton.setImage(UIImage(named: "btnCheckBox"), for: .selected)
        
        withdrawalLabel.font = .p2Subtitle
        withdrawalLabel.textColor = .sparkDarkGray
        withdrawalLabel.text = "위의 사항을 숙지하였으며, 이에 동의합니다."
        
        withdrawalButton.setTitle("탈퇴하기")
            .setDisable()
    }
    
    private func setAddTargets() {
        withdrawalButton.addTarget(self, action: #selector(touchWithdrawalButtonButton), for: .touchUpInside)
    }

    // MARK: - @Objc Methods
    
    @objc
    private func touchWithdrawalButtonButton() {
        // TODO: - 탈퇴하기 서버통신
    }
}

// MARK: - Layout

extension WithdrawalVC {
    private func setLayout() {
        view.addSubviews([customNavigationBar, titleLabel, topDividerLine, subtitleLabel, firstCircleLabel, firstTextView, secondCircleLabel, secondTextView, bottomDividerLine, checkboxButton, withdrawalLabel, withdrawalButton])
        
        customNavigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        topDividerLine.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(23.5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(topDividerLine.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        firstCircleLabel.snp.makeConstraints {
            $0.leading.equalTo(subtitleLabel.snp.leading)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
        }
        
        firstTextView.snp.makeConstraints {
            $0.top.equalTo(firstCircleLabel.snp.top)
            $0.leading.equalTo(firstCircleLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        secondCircleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(firstTextView.snp.bottom).offset(20)
        }
        
        secondTextView.snp.makeConstraints {
            $0.top.equalTo(secondCircleLabel.snp.top)
            $0.leading.equalTo(secondCircleLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        topDividerLine.snp.makeConstraints {
            $0.top.equalTo(secondTextView.snp.bottom).offset(17.5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.top.equalTo(topDividerLine.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(20)
        }
        
        withdrawalLabel.snp.makeConstraints {
            $0.leading.equalTo(checkboxButton.snp.trailing).offset(8)
            $0.centerY.equalTo(checkboxButton.snp.centerY)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
