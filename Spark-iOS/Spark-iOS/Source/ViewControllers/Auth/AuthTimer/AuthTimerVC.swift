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
    
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    private let stopwatchLabel = UILabel()
    private let photoLabel = UILabel()
    private let betweenLine = UIView()
    private let divideLine = UIView()
    private let timeLabel = UILabel()
    private let bottomButton = BottomButton().setUI(.pink)
    private let pauseButton = UIButton()
    private let resetButton = UIButton()
    private let customNavigationBar = LeftButtonNavigaitonBar()
    
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
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkForground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkForground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - Methods
    
    private func setUI() {
        customNavigationBar.title(roomName ?? "")
            .leftButtonImage("icQuit")
            .leftButtonAction {
                self.dismissAuthTimerVC()
            }
        
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
        
        pauseButton.setImage(UIImage(named: "btnStop"), for: .normal)
        resetButton.setImage(UIImage(named: "btnReset"), for: .normal)
        
        [pauseButton, resetButton].forEach { $0.isHidden = true }
    }
    
    private func setAddTarget() {
        pauseButton.addTarget(self, action: #selector(startPauseTimer(_:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(showResetPopup), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(touchNextButton), for: .touchUpInside)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetTimer(_:)), name: .resetStopWatch, object: nil)
        // 백그라운드에서 포어그라운드로 돌아올때
        NotificationCenter.default.addObserver(self, selector: #selector(checkForground), name: NSNotification.Name("sceneWillEnterForeground"), object: nil)
        // 포어그라운드에서 백그라운드로 갈때
        NotificationCenter.default.addObserver(self, selector: #selector(checkForground(_:)), name: NSNotification.Name("sceneDidEnterBackground"), object: nil)
    }
    
    private func setButton(_ button: UIButton, title: String, backgroundColor: UIColor, isEnable: Bool) {
        button.setTitle(title, for: UIControl.State())
        button.isEnabled = isEnable
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = .enBoldFont(ofSize: 18)
        button.layer.cornerRadius = 2
    }
    
    private func dismissAuthTimerVC() {
        if timeLabel.text != "00:00:00" {
            guard let dialogVC = UIStoryboard(name: Const.Storyboard.Name.dialogue, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.dialogue) as? DialogueVC else { return }
            dialogVC.dialogueType = .exitTimer
            dialogVC.clousure = {
                self.dismiss(animated: true, completion: nil)
            }
            dialogVC.modalPresentationStyle = .overFullScreen
            dialogVC.modalTransitionStyle = .crossDissolve
            self.present(dialogVC, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func timeFormatter(_ intTime: Int) -> String {
        let hour = intTime / 3600
        let min = (intTime % 3600) / 60
        let sec = (intTime % 3600) % 60
        
        let hourStr =  hour < 10 ? "0\(hour)" : String(hour)
        let minStr = min < 10 ? "0\(min)" : String(min)
        let secStr = sec < 10 ? "0\(sec)" : String(sec)
        
        return "\(hourStr):\(minStr):\(secStr)"
    }
    
    // MARK: - @objc
    
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
    
    @objc
    func checkForground(_ notification: NSNotification) {
        if let isValid = timer?.isValid {
            if isTimerOn && isValid {
                let time = notification.userInfo?["time"] as? Int ?? 0
                currentTimeCount += time
            }
        }
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
        setButton(bottomButton, title: "시작하기", backgroundColor: .sparkDarkPinkred, isEnable: true)
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
        view.addSubviews([customNavigationBar, firstLabel, secondLabel,
                          stopwatchLabel, photoLabel, betweenLine,
                          divideLine, timeLabel, bottomButton,
                         pauseButton, resetButton])
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        betweenLine.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(32)
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
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.trailing.equalTo(view.snp.centerX).offset(-11)
            make.width.height.equalTo(60)
        }
        
        pauseButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.centerX).offset(11)
            make.width.height.equalTo(60)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension AuthTimerVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
