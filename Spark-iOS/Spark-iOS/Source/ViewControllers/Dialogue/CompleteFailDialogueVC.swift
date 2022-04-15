//
//  CompleteFailDialogueVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/12.
//

import UIKit

import SnapKit
import Lottie

class CompleteFailDialogueVC: UIViewController {

    // MARK: - Properties
    
    private let bgView = UIView()
    private let sparkFlakePatternImageView = UIImageView()
    private let lottieView = UIView()
    private lazy var successLottieView = AnimationView(name: Const.Lottie.Name.homeCardSuccess)
    private lazy var failLottieView = AnimationView(name: Const.Lottie.Name.homeCardFail)
    private let titleLabel = UILabel()
    private let subtitleLable = UILabel()
    private let button = UIButton()
    
    var roomID: Int?
    var roomStatus: RoomStatus?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setAddTargets()
    }
}

// MARK: - Extensions

extension CompleteFailDialogueVC {
    private func setUI() {
        self.view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        bgView.backgroundColor = .sparkWhite
        bgView.layer.cornerRadius = 2

        sparkFlakePatternImageView.image = UIImage(named: "sparkflakePattern2")
        
        titleLabel.textColor = .sparkPinkred
        titleLabel.font = .enMediumItatlicFont(ofSize: 24.0)
        
        subtitleLable.textColor = .sparkDeepGray
        subtitleLable.font = .p1TitleLight
        subtitleLable.numberOfLines = 2
        subtitleLable.textAlignment = .center
        
        if let roomStatus = roomStatus {
            switch roomStatus {
            case .complete:
                titleLabel.text = "Congratulations!"
                subtitleLable.text = """
                66일간의 도전 성공!
                여기까지 달려온 나를 마음껏 칭찬해주기!
                """
            case .fail:
                titleLabel.text = "Don’t give up!"
                subtitleLable.text = """
                성공하진 못했어도 실패는 아니에요.
                그러니 언제든 주저 말고 다시 도전하기!
                """
            case .done, .rest, .none:
                return
            }
        }
        
        button.setTitle("확인했어요", for: .normal)
        button.setTitleColor(.sparkWhite, for: .normal)
        button.titleLabel?.font = .btn1Default
        button.backgroundColor = .sparkBlack
    }
    
    private func setAddTargets() {
        button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
    }
    
    private func setLayout() {
        view.addSubview(bgView)
        
        bgView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(bgView.snp.width).multipliedBy(1.18)
        }
        
        bgView.addSubviews([sparkFlakePatternImageView, lottieView, titleLabel, subtitleLable, button])
        
        sparkFlakePatternImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(21)
        }
        
        lottieView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.width.equalTo(242)
            $0.height.equalTo(170)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(lottieView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLable.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(28)
            $0.leading.trailing.equalToSuperview().inset(106)
            $0.height.equalTo(button.snp.width).multipliedBy(0.4)
        }
        
        switch roomStatus {
        case .complete:
            lottieView.addSubview(successLottieView)
            successLottieView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            successLottieView.loopMode = .loop
            successLottieView.contentMode = .scaleAspectFit
            successLottieView.play()
        case .fail:
            lottieView.addSubview(failLottieView)
            failLottieView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            failLottieView.loopMode = .loop
            failLottieView.contentMode = .scaleAspectFit
            failLottieView.play()
        default:
            return
        }
    }
    
    // MARK: - Screen Change
    
    private func dismissCompleteFailDialogueVC() {
        readRoomWithAPI {
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .updateHome, object: nil)
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func touchButton() {
        dismissCompleteFailDialogueVC()
    }
}

// MARK: - Network

extension CompleteFailDialogueVC {
    private func readRoomWithAPI(completion: @escaping () -> Void) {
        RoomAPI(viewController: self).readRoom(roomID: roomID ?? -1) { response in
            switch response {
            case .success(let message):
                
                completion()
                print("readRoomWithAPI - success: \(message)")
            case .requestErr(let message):
                print("readRoomWithAPI - requestErr: \(message)")
            case .pathErr:
                print("readRoomWithAPI - pathErr")
            case .serverErr:
                print("readRoomWithAPI - serverErr")
            case .networkFail:
                print("readRoomWithAPI - networkFail")
            }
        }
    }
}
