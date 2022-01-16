//
//  AuthUploadVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/16.
//

import UIKit

import SnapKit

@frozen enum VCCase {
    case cameraTimer
    case albumTimer
    case cameraOnly
    case albumOnly
}

class AuthUploadVC: UIViewController {
    
    // MARK: - Properties
    
    var vcType: VCCase = .cameraTimer
    var uploadImageView = UIImageView()
    var uploadImage = UIImage()
    var buttonStackView = UIStackView()
    var uploadButton = UIButton()
    var retakeButton = UIButton()
    var timerLabel = UILabel()
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    let stopwatchLabel = UILabel()
    let photoLabel = UILabel()
    let betweenLine = UIView()
    let photoAuthButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setSecondFlowUI()
    }
}

// MARK: - Methods
extension AuthUploadVC {
    private func setUI() {
        firstLabel.text = "1"
        secondLabel.text = "2"
        stopwatchLabel.text = "스톱워치"
        photoLabel.text = "사진 인증"
        
        firstLabel.textColor = .sparkPinkred
        secondLabel.textColor = .sparkGray
        stopwatchLabel.textColor = .sparkPinkred
        photoLabel.textColor = .sparkGray
        
        firstLabel.font = .enMediumFont(ofSize: 18)
        secondLabel.font = .enMediumFont(ofSize: 18)
        stopwatchLabel.font = .krMediumFont(ofSize: 18)
        photoLabel.font = .krRegularFont(ofSize: 18)
        
        betweenLine.backgroundColor = .sparkPinkred
        
        photoAuthButton.layer.cornerRadius = 2
        photoAuthButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        photoAuthButton.setTitle("사진 인증하기", for: .normal)
        photoAuthButton.backgroundColor = .sparkDarkPinkred
        
        uploadImageView.backgroundColor = .sparkLightGray
        uploadImageView.image = uploadImage
        uploadImageView.contentMode = .scaleToFill
        
        setStackView()
        
        timerLabel.text = "00:30:12"
        timerLabel.font = .enBoldFont(ofSize: 40)
        timerLabel.textColor = .sparkWhite
        
        retakeButton.layer.cornerRadius = 2
        retakeButton.titleLabel?.font = .btn1Default
        retakeButton.setTitle("다시 찍기", for: .normal)
        retakeButton.backgroundColor = .sparkWhite
        retakeButton.tintColor = .sparkDarkPinkred
        retakeButton.setTitleColor(.sparkDarkPinkred, for: .normal)
        retakeButton.layer.borderWidth = 2
        retakeButton.layer.borderColor = .init(red: 1, green: 0, blue: 61/255, alpha: 1)
        retakeButton.isEnabled = true
        
        uploadButton.layer.cornerRadius = 2
        uploadButton.titleLabel?.font = .btn1Default
        uploadButton.setTitle("업로드", for: .normal)
        uploadButton.backgroundColor = .sparkDarkPinkred
        uploadButton.isEnabled = true
        
        switch vcType {
        case .cameraOnly:
            print("카메라")
            timerLabel.isHidden = true
            
        case .albumOnly:
            print("앨범")
            retakeButton.setTitle("다시 선택", for: .normal)
            timerLabel.isHidden = true

        case .cameraTimer:
            print("카메라타이머")
            
        case .albumTimer:
            print("앨범타이머")
            retakeButton.setTitle("다시 선택", for: .normal)
        }
    }
    
    func setFirstFlowUI() {
        
    }
    
    func setSecondFlowUI() {
        
    }
    
    private func setStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        buttonStackView.addArrangedSubview(retakeButton)
        buttonStackView.addArrangedSubview(uploadButton)
    }
}

// MARK: - Layout
extension AuthUploadVC {
    private func setLayout() {
        view.addSubviews([uploadImageView, buttonStackView, timerLabel,
                          firstLabel, secondLabel, stopwatchLabel,
                          photoLabel, betweenLine, photoAuthButton])

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
        
        photoAuthButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(self.view.frame.width*48/335)
        }
        
        uploadImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(220)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(self.view.frame.width*48/335)
        }
        
        retakeButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(160)
        }
        
        uploadButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(160)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(uploadImageView)
        }
    }
}
