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
    
    let stopwatch: Stopwatch = Stopwatch()
    var isPlay: Bool = false
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setButton(startButton, title: "시간 측정 시작", backgroundColor: .sparkDarkPinkred, isEnable: true)
        setAddTarget()
        setNotification()
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
    
    private func setAddTarget() {
        pauseButton.addTarget(self, action: #selector(startPauseTimer(_:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(showResetPopup), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(touchNextButton), for: .touchUpInside)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetTimer(_:)), name: .resetStopWatch, object: nil)
    }
    
    private func setButton(_ button: UIButton, title: String, backgroundColor: UIColor, isEnable: Bool) {
        button.setTitle(title, for: UIControl.State())
        button.isEnabled = isEnable
        button.backgroundColor = backgroundColor
    }
    
    private func resetMainTimer() {
        resetTimer(stopwatch, label: timeLabel)
    }
    
    /// stopwatch를 멈추고, label을 reset하는 함수
    private func resetTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        label.text = "00:00:00"
    }
    
    /// timer를 증가시키면서 label의 값에 반영시키는 함수
    private func updateTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.counter = stopwatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        
        label.text = minutes + ":" + seconds
    }
    
    // MARK: - @objc
    /// start 버튼을 눌렀을 때 isPlay의 상태에 따라 버튼, 라벨 상태 변경
    @objc
    func startPauseTimer(_ sender: AnyObject) {
        /// 실행중 X, 스톱워치 시작 + 버튼 변경
        /// 실행중 O, 스톱워치
        if !isPlay {
            unowned let weakSelf = self
            
            /// 0.035초마다 updateMainTimer 함수 호출하는 타이머
            stopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
            
            /// RunLoop에서 timer 객체를 추가해서 관리
            RunLoop.current.add(stopwatch.timer, forMode: .common)
            
            /// 실행X -> 실행O
            isPlay = true
            pauseButton.backgroundColor = .blue
            setButton(startButton, title: "다음 단계로", backgroundColor: .sparkGray, isEnable: false)
        } else {
            /// RunLoop 객체로부터 timer를 제거하기 위한 함수 (반복 타이머 중지)
            stopwatch.timer.invalidate()
            
            /// 실행O -> 실행X
            isPlay = false
            pauseButton.backgroundColor = .red
            setButton(startButton, title: "다음 단계로", backgroundColor: .sparkDarkPinkred, isEnable: true)
        }
    }
    
    @objc
    func showResetPopup() {
        guard let popupVC = UIStoryboard(name: Const.Storyboard.Name.resetPopup, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.resetPopup) as? ResetPopupVC else { return }
        
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.time = timeLabel.text ?? ""
        
        present(popupVC, animated: true, completion: nil)
    }
    
    @objc
    func resetTimer(_ sender: AnyObject) {
        /// 실행중 X (스톱워치가 멈춘 상태라면), reset
        /// 실행중 O (스톱워치가 돌아가는 상태라면), print
        if !isPlay {
            resetMainTimer()
            setButton(startButton, title: "시간 측정 시작", backgroundColor: .sparkDarkPinkred, isEnable: true)
            pauseButton.backgroundColor = .blue /// 재생버튼
        }
    }
    
    @objc
    func updateMainTimer() {
        updateTimer(stopwatch, label: timeLabel)
    }
    
    @objc
    func touchNextButton() {
        // TODO: - 화면 전환 + timeLabel.text 넘겨주기
        print("time: \(timeLabel.text)")
    }
}

// MARK: - Layout
extension AuthTimerVC {
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
