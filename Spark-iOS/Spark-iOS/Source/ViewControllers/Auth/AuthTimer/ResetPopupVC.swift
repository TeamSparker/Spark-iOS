//
//  ResetPopupVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/16.
//

import UIKit

class ResetPopupVC: UIViewController {
    
    // MARK: - Properties
    let backView = UIView()
    let titleLabel = UILabel()
    let cancelButton = UIButton()
    let resetButton = UIButton()
    let horizontalLine = UIView()
    let verticalLine = UIView()
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setAddTarget()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 2
        
        titleLabel.text = "스톱워치를 초기화 할까요?"
        cancelButton.setTitle("취소", for: .normal)
        resetButton.setTitle("초기화", for: .normal)
        
        titleLabel.font = .p1TitleLight
        cancelButton.titleLabel?.font = .btn3
        resetButton.titleLabel?.font = .btn3
        
        titleLabel.textColor = .sparkBlack
        cancelButton.setTitleColor(.sparkGray, for: .normal)
        resetButton.setTitleColor(.sparkDarkPinkred, for: .normal)
        
        horizontalLine.backgroundColor = .sparkLightGray
        verticalLine.backgroundColor = .sparkLightGray
    }
    
    private func setAddTarget() {
        cancelButton.addTarget(self, action: #selector(touchCancelButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(touchResetButton), for: .touchUpInside)
    }
    
    // TODO: - 화면전환
    @objc
    func touchCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func touchResetButton() {
        NotificationCenter.default.post(name: .resetStopWatch, object: nil)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Layout
extension ResetPopupVC {
    private func setLayout() {
        view.addSubviews([backView])
        
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(121)
        }
        
        backView.addSubviews([titleLabel, cancelButton, resetButton,
                              horizontalLine, verticalLine])
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(25)
        }
        
        horizontalLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.height.equalTo(1)
        }
        
        verticalLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(horizontalLine.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(verticalLine.snp.centerY)
            make.leading.equalToSuperview()
            make.trailing.equalTo(verticalLine.snp.leading)
        }
        
        resetButton.snp.makeConstraints { make in
            make.centerY.equalTo(verticalLine.snp.centerY)
            make.leading.equalTo(verticalLine.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
}
