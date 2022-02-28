//
//  CreateSuccessVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/02/27.
//

import UIKit

import SnapKit

class CreateSuccessVC: UIViewController {
    
    // MARK: - Properties

    private let titleLabel = UILabel()
    private let guideLabel = UILabel()
    private let copyButton = UIButton()
    private let wantImageView = UIImageView()
    private let homeButton = BottomButton().setUI(.white).setTitle("홈으로 가기")
    private let enterButton = BottomButton().setUI(.pink).setTitle("대기방 입장하기")
    
    var roomName: String?
    var roomCode: String?
    var roomId: Int?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }
    
    // MARK: - Custom Methods
    
    private func setUI() {
        titleLabel.text = "\(roomName ?? "")\n방을 만들었어요!"
        titleLabel.font = .h2Title
        titleLabel.textAlignment = .center
        titleLabel.textColor = .sparkPinkred
        titleLabel.partColorChange(targetString: "방을 만들었어요!", textColor: .sparkBlack)
        titleLabel.numberOfLines = 2
        
        guideLabel.text = "코드를 복사해 친구들을 초대해 보세요!"
        guideLabel.font = .p1TitleLight
        guideLabel.textAlignment = .center
        guideLabel.textColor = .sparkDarkGray
        
        copyButton.setImage(UIImage(named: "btnSmall"), for: .normal)
        
        wantImageView.backgroundColor = .gray
    }
    
    private func setAddTarget() {
        copyButton.addTarget(self, action: #selector(copyToClipboard), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(touchHomeButton), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(touchEnterButton), for: .touchUpInside)
    }
    
    // MARK: - @objc
    
    @objc
    private func copyToClipboard() {
        UIPasteboard.general.string = roomCode
        showToast(x: 20, y: view.safeAreaInsets.top, message: "코드를 복사했어요!", font: .p1TitleLight)
    }
    
    @objc
    private func touchHomeButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func touchEnterButton() {
        guard let rootVC = UIStoryboard(name: Const.Storyboard.Name.waiting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.waiting) as? WaitingVC else { return }
        rootVC.roomName = self.roomName
        rootVC.roomId = self.roomId
        rootVC.fromWhereStatus = .makeRoom
        
        let nextVC = UINavigationController(rootViewController: rootVC)
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .fullScreen
        
        self.present(nextVC, animated: true)
    }
}

// MARK: - Network
extension CreateSuccessVC {
    // TODO: - 코드복사할 roomCode를 가져오기 위해 서버 통신
}

// MARK: - Layout
extension CreateSuccessVC {
    private func setLayout() {
        view.addSubviews([titleLabel, guideLabel, copyButton,
                         wantImageView, homeButton, enterButton])
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(68)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        copyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(guideLabel.snp.bottom).offset(20)
            make.width.equalTo(87)
            make.height.equalTo(36)
        }
        
        wantImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
            make.top.equalTo(copyButton.snp.bottom).offset(28)
        }
        
        enterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        homeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(enterButton.snp.top).offset(-16)
        }
    }
    
}
