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
    
    var isTimerOn: Bool = false
    var currentTimeCount: Int = 0
    var timer: Timer?
    
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
        photoLabel.text = "사진"
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
        
        pauseButton.setImage(UIImage(named: "btnStop"), for: .normal)
        resetButton.setImage(UIImage(named: "btnReset"), for: .normal)
        
        [pauseButton, resetButton].forEach { $0.isHidden = true }
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
    
    // MARK: - @objc
    /// start 버튼을 눌렀을 때 isPlay의 상태에 따라 버튼, 라벨 상태 변경
    @objc
    func startPauseTimer(_ sender: AnyObject) {
        if isTimerOn == false {
            // 최초 시작
            isTimerOn = true
            resetButton.isHidden = false
            pauseButton.isHidden = false
            pauseButton.setImage(UIImage(named: "btnStop"), for: .normal)
            setButton(startButton, title: "다음 단계로", backgroundColor: .sparkGray, isEnable: false)
            [pauseButton, resetButton].forEach { $0.isHidden = false }
            timeLabel.text = timeFormatter(currentTimeCount)
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            // stop 버튼 활성화
            startButton.isEnabled = true
        } else if isTimerOn && timer!.isValid {
            // 타이머 진행 중 일시정지
            pauseButton.setImage(UIImage(named: "btnPlay"), for: .normal)
            setButton(startButton, title: "다음 단계로", backgroundColor: .sparkDarkPinkred, isEnable: true)
            timer?.invalidate()
        } else if isTimerOn && !(timer!.isValid) {
            // 일시정지상태에서 재개
            pauseButton.setImage(UIImage(named: "btnStop"), for: .normal)
            setButton(startButton, title: "다음 단계로", backgroundColor: .sparkGray, isEnable: false)
            [pauseButton, resetButton].forEach { $0.isHidden = false }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    func timeFormatter(_ intTime: Int) -> String {
        let hour = intTime / 3600
        let min = (intTime % 3600) / 60
        let sec = (intTime % 3600) % 60
        
        let hourStr =  hour < 10 ? "0\(hour)" : String(hour)
        let minStr = min < 10 ? "0\(min)" : String(min)
        let secStr = sec < 10 ? "0\(sec)" : String(sec)
        
        return "\(hourStr):\(minStr):\(secStr)"
    }
    
    @objc
    func updateTime() {
        currentTimeCount += 1
        timeLabel.text = timeFormatter(currentTimeCount)
    }
    
    @objc
    func showResetPopup() {
        guard let popupVC = UIStoryboard(name: Const.Storyboard.Name.resetPopup, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.resetPopup) as? ResetPopupVC else { return }
        
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        
        present(popupVC, animated: true, completion: nil)
    }
    
    @objc
    func resetTimer(_ sender: AnyObject) {
        currentTimeCount = 0
        timeLabel.text = "00:00:00"
        setButton(startButton, title: "시간 측정 시작", backgroundColor: .sparkDarkPinkred, isEnable: true)
        pauseButton.setImage(UIImage(named: "btnStop"), for: .normal)
        [pauseButton, resetButton].forEach { $0.isHidden = true }
    }
    
    @objc
    func touchNextButton() {
        if timeLabel.text == "00:00:00" {
            // 재생X -> 스톱워치 시작
            startPauseTimer(startButton)
        } else {
            guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.authUpload, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.authUpload) as? AuthUploadVC else { return }
            
            // TODO: - timeLabel.text 넘겨주기
            nextVC.timerLabel.text = timeLabel.text
            
            navigationController?.pushViewController(nextVC, animated: true)
        }
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
