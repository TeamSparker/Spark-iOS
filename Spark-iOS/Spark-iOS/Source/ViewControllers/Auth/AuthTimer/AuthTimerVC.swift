//
//  AuthTimerVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/15.
//

import UIKit

import SnapKit

class AuthTimerVC: UIViewController {
    
    // MARK: - Properties
    
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    let stopwatchLabel = UILabel()
    let photoLabel = UILabel()
    let betweenLine = UIView()
    let divideLine = UIView()
    let timeLabel = UILabel()
    let startButton = UIButton()
    
    let pauseButton = UIButton()
    let resetButton = UIButton()
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setDefaultButton()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        firstLabel.text = "1"
        secondLabel.text = "2"
        stopwatchLabel.text = "스톱워치"
        photoLabel.text = "사진 인증"
        timeLabel.text = "00:00:00"
        
        firstLabel.font = .enMediumFont(ofSize: 18)
        secondLabel.font = .enMediumFont(ofSize: 18)
        stopwatchLabel.font = .krMediumFont(ofSize: 18)
        photoLabel.font = .krRegularFont(ofSize: 18)
        timeLabel.font = .enBoldFont(ofSize: 50)
        
        betweenLine.backgroundColor = .sparkPinkred
        divideLine.backgroundColor = .sparkLightGray
        
        firstLabel.textColor = .sparkPinkred
        secondLabel.textColor = .sparkGray
        stopwatchLabel.textColor = .sparkPinkred
        photoLabel.textColor = .sparkGray
        
        startButton.layer.cornerRadius = 2
        startButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        
        pauseButton.backgroundColor = .blue
        resetButton.backgroundColor = .yellow
    }
    
    private func setDefaultButton() {
        startButton.setTitle("시간 측정 시작", for: .normal)
        startButton.backgroundColor = .sparkDarkPinkred
    }
    
    private func setUnactiveNextButton() {
        startButton.setTitle("다음 인증으로", for: .normal)
        startButton.isEnabled = true
        startButton.backgroundColor = .sparkGray
    }
    
    private func setActiveNextButton() {
        startButton.setTitle("다음 인증으로", for: .normal)
        startButton.isEnabled = false
        startButton.backgroundColor = .sparkDarkPinkred
    }
    
    private func setLayout() {
        view.addSubviews([firstLabel, secondLabel, stopwatchLabel, photoLabel,
                         betweenLine, divideLine, timeLabel, startButton,
                         pauseButton, resetButton])
        
        betweenLine.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(2)
        }
        
        firstLabel.snp.makeConstraints { make in
            make.centerY.equalTo(betweenLine.snp.centerY)
            make.trailing.equalTo(betweenLine.snp.leading).offset(-20)
        }
        
        secondLabel.snp.makeConstraints { make in
            make.centerY.equalTo(betweenLine.snp.centerY)
            make.leading.equalTo(betweenLine.snp.trailing).offset(20)
        }
        
        stopwatchLabel.snp.makeConstraints { make in
            make.centerX.equalTo(firstLabel.snp.centerX)
            make.top.equalTo(firstLabel.snp.bottom).offset(6)
        }
        
        photoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(secondLabel.snp.centerX)
            make.top.equalTo(secondLabel.snp.bottom).offset(6)
        }
        
        divideLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(betweenLine.snp.bottom).offset(85)
            make.height.equalTo(0.5)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(275)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(self.view.frame.width*48/335)
        }
        
        pauseButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.trailing.equalTo(view.snp.centerX).offset(-11)
            make.width.height.equalTo(60)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.centerX).offset(11)
            make.width.height.equalTo(60)
        }
    }
}
