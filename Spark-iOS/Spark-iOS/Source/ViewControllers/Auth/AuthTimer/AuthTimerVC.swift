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
    
    let titleLabel = UILabel()
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    let stopwatchLabel = UILabel()
    let photoLabel = UILabel()
    let betweenLine = UIView()
    let divideLine = UIView()
    let timeLabel = UILabel()
    let bottomButton = UIButton()
    let pauseButton = UIButton()
    let resetButton = UIButton()
    let closeButton = UIButton()
    
    var isTimerOn: Bool = false
    var currentTimeCount: Int = 0
    var timer: Timer?
    var roomName: String?
    var roomId: Int?
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setButton(bottomButton, title: "시작하기", backgroundColor: .sparkDarkPinkred, isEnable: true)
        setAddTarget()
        setNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Methods
    
    private func setUI() {
        if let name = roomName {
            navigationController?.initWithLeftButtonTitle(title: "\(name)",
                                                          tintColor: .sparkBlack,
                                                          backgroundColor: .sparkWhite,
                                                          image: UIImage(named: "icQuit"),
                                                          selector: #selector(dismissToHabitRoom))
        }
        
        titleLabel.text = "\(roomName ?? "-")"
        firstLabel.text = "1"
        secondLabel.text = "2"
        stopwatchLabel.text = "스톱워치"
        photoLabel.text = "사진"
        timeLabel.text = "00:00:00"
        
        titleLabel.font = .h3Subtitle
        firstLabel.font = .enMediumFont(ofSize: 18)
        secondLabel.font = .enMediumFont(ofSize: 18)
        stopwatchLabel.font = .krMediumFont(ofSize: 18)
        photoLabel.font = .krRegularFont(ofSize: 18)
        timeLabel.font = .enBoldFont(ofSize: 50)
        
        betweenLine.backgroundColor = .sparkPinkred
        divideLine.backgroundColor = .sparkLightGray
        
        titleLabel.textColor = .sparkBlack
        firstLabel.textColor = .sparkPinkred
        secondLabel.textColor = .sparkGray
        stopwatchLabel.textColor = .sparkPinkred
        photoLabel.textColor = .sparkGray
        
        bottomButton.layer.cornerRadius = 2
        bottomButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        
        closeButton.setImage(UIImage(named: "icQuit"), for: .normal)
        pauseButton.setImage(UIImage(named: "btnStop"), for: .normal)
        resetButton.setImage(UIImage(named: "btnReset"), for: .normal)
        
        [pauseButton, resetButton].forEach { $0.isHidden = true }
    }
    
    private func setAddTarget() {
        closeButton.addTarget(self, action: #selector(dismissToHabitRoom), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(startPauseTimer(_:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(showResetPopup), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(touchNextButton), for: .touchUpInside)
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
    @objc
    func dismissToHabitRoom() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func startPauseTimer(_ sender: AnyObject) {
        if isTimerOn == false {
            // 최초 시작
            isTimerOn = true
            pauseButton.setImage(UIImage(named: "btnStop"), for: .normal)
            setButton(bottomButton, title: "다음 단계로", backgroundColor: .sparkGray, isEnable: false)
            [pauseButton, resetButton].forEach { $0.isHidden = false }
            timeLabel.text = timeFormatter(currentTimeCount)
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            // stop 버튼 활성화
            bottomButton.isEnabled = true
        } else if isTimerOn && timer!.isValid {
            // 타이머 진행 중 일시정지
            isTimerOn = false
            pauseButton.setImage(UIImage(named: "btnPlay"), for: .normal)
            setButton(bottomButton, title: "다음 단계로", backgroundColor: .sparkDarkPinkred, isEnable: true)
            timer?.invalidate()
        } else if isTimerOn && !(timer!.isValid) {
            // 일시정지상태에서 재개
            isTimerOn = true
            pauseButton.setImage(UIImage(named: "btnStop"), for: .normal)
            setButton(bottomButton, title: "다음 단계로", backgroundColor: .sparkGray, isEnable: false)
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
        if !isTimerOn {
            guard let popupVC = UIStoryboard(name: Const.Storyboard.Name.resetPopup, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.resetPopup) as? ResetPopupVC else { return }
            
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            
            present(popupVC, animated: true, completion: nil)
        }
    }
    
    @objc
    func resetTimer(_ sender: AnyObject) {
        currentTimeCount = 0
        timeLabel.text = "00:00:00"
        setButton(bottomButton, title: "시간 측정 시작", backgroundColor: .sparkDarkPinkred, isEnable: true)
        pauseButton.setImage(UIImage(named: "btnStop"), for: .normal)
        [pauseButton, resetButton].forEach { $0.isHidden = true }
    }
    
    @objc
    func touchNextButton() {
        if timeLabel.text == "00:00:00" {
            // 재생X -> 스톱워치 시작
            startPauseTimer(bottomButton)
        } else {
            if !isTimerOn {
                guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.authUpload, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.authUpload) as? AuthUploadVC else { return }
                
                nextVC.timerLabel.text = timeLabel.text
                nextVC.vcType = .photoTimer
                nextVC.roomName = roomName
                nextVC.roomId = roomId
                
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}

// MARK: - Layout
extension AuthTimerVC {
    private func setLayout() {
        view.addSubviews([titleLabel, closeButton, firstLabel, secondLabel,
                          stopwatchLabel, photoLabel, betweenLine,
                          divideLine, timeLabel, bottomButton,
                         pauseButton, resetButton])
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton.snp.centerY)
        }
        
        betweenLine.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32+44)
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(UIScreen.main.hasNotch ? 275 : 200)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
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
