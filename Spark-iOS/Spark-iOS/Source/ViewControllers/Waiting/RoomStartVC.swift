//
//  RoomStartVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/02/21.
//

import UIKit

import SnapKit

class RoomStartVC: UIViewController {
    
    // MARK: - Properties
    
    private let popupView = UIView()
    private let titleLabel = UILabel()
    private let userImageView = UIImageView()
    private let phoneImageView = UIImageView()
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    private let horizonLineView = UIView()
    private let verticalLineView = UIView()
    private let cancelButton = UIButton()
    private let startButton = UIButton()
    
    var roomID: Int?
    var startSuccess: Bool = false
    var completionHandler: ((Bool) -> Void)?
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        popupView.backgroundColor = .sparkWhite
        popupView.layer.cornerRadius = 2
        
        titleLabel.text = "습관 시작 전 잠깐!"
        titleLabel.textColor = .sparkMoreDeepGray
        titleLabel.font = .p1Title
        
        userImageView.image = UIImage(named: "icBanuser")
        phoneImageView.image = UIImage(named: "icPhone")
        
        firstLabel.text = "첫째, 습관 시작 후에는 인원 추가가\n불가능해요."
        firstLabel.textColor = .sparkDarkGray
        firstLabel.font = .p1TitleLight
        firstLabel.numberOfLines = 2
        
        secondLabel.text = "둘째, 오늘부터 습관을 실행하고 \n인증해야 해요."
        secondLabel.textColor = .sparkDarkGray
        secondLabel.font = .p1TitleLight
        secondLabel.numberOfLines = 2
        
        horizonLineView.backgroundColor = .sparkLightGray
        verticalLineView.backgroundColor = .sparkLightGray
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.sparkDarkGray, for: .normal)
        cancelButton.titleLabel?.font = .krMediumFont(ofSize: 16)
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.sparkDarkPinkred, for: .normal)
        startButton.titleLabel?.font = .krMediumFont(ofSize: 16)
    }
    
    private func setAddTarget() {
        cancelButton.addTarget(self, action: #selector(dismissRoomStart), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(touchStartButton), for: .touchUpInside)
    }
    
    // MARK: - @objc
    
    @objc
    func touchStartButton() {
        postStartRoomWithAPI(roomID: self.roomID ?? 0) {
            self.dismiss(animated: true) {
                self.completionHandler?(self.startSuccess)
            }
        }
    }
    
    @objc
    func dismissRoomStart() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Network

extension RoomStartVC {
    private func postStartRoomWithAPI(roomID: Int, completion: @escaping () -> Void) {
        RoomAPI.shared.startRoomWithAPI(roomID: roomID) { response in
            switch response {
            case .success(let message):
                self.startSuccess = true
                completion()
                print("postStartRoomWithAPI - success: \(message)")
            case .requestErr(let message):
                print("postStartRoomWithAPI - requestErr: \(message)")
            case .pathErr:
                print("postStartRoomWithAPI - pathErr")
            case .serverErr:
                print("postStartRoomWithAPI - serverErr")
            case .networkFail:
                print("postStartRoomWithAPI - networkFail")
            }
        }
    }
}

// MARK: - Layout

extension RoomStartVC {
    private func setLayout() {
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo((UIScreen.main.bounds.width - 40) * 250 / 335)
        }
        
        popupView.addSubviews([titleLabel, userImageView, phoneImageView,
                               firstLabel, secondLabel, horizonLineView,
                               verticalLineView, cancelButton, startButton])
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(25)
        }
        
        userImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(27)
            make.width.height.equalTo(40)
        }
        
        phoneImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(userImageView.snp.bottom).offset(22)
            make.width.height.equalTo(40)
        }
        
        firstLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(userImageView.snp.centerY)
        }
        
        secondLabel.snp.makeConstraints { make in
            make.leading.equalTo(phoneImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(phoneImageView.snp.centerY)
        }
        
        horizonLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(47)
            make.height.equalTo(1)
        }
        
        verticalLineView.snp.makeConstraints { make in
            make.top.equalTo(horizonLineView.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(horizonLineView.snp.bottom)
            make.trailing.equalTo(verticalLineView.snp.leading)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.equalTo(verticalLineView.snp.trailing)
            make.top.equalTo(horizonLineView.snp.bottom)
            make.trailing.bottom.equalToSuperview()
        }
    }
}
