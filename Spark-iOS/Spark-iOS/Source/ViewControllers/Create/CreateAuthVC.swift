//
//  CreateAuthVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/14.
//

import UIKit

import SnapKit

class CreateAuthVC: UIViewController {
    
    // MARK: - Properties
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let photoAuthView = PhotoAuthView()
    let timerAuthView = TimerAuthView()
    let enterButton = UIButton()
    /// photoOnly가 true이면 fromStart가 false
    var photoOnly: Bool = true
    var roomName: String = ""
    var roomId: Int?

    // MARK: - View Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setUI()
        setLayout()
        setAddTarget()
        setAuthViewState()
        setGesture()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        navigationController?.initWithBackButtonTitle(title: "",
                                                      tintColor: .sparkBlack,
                                                      backgroundColor: .sparkWhite)
        
        titleLabel.text = "어떻게 습관을 인증할까요?"
        titleLabel.font = .h2Title
        titleLabel.textColor = .sparkBlack
        
        subTitleLabel.text = "습관 유형에 알맞는 인증 방식을\n선택해 주세요."
        subTitleLabel.numberOfLines = 2
        subTitleLabel.font = .krRegularFont(ofSize: 18)
        subTitleLabel.textColor = .sparkDarkGray
        
        enterButton.layer.cornerRadius = 2
        enterButton.titleLabel?.font = .enBoldFont(ofSize: 18)
        enterButton.setTitle("대기방 입장하기", for: .normal)
        enterButton.backgroundColor = .sparkPinkred
        
        photoAuthView.setSelectedUI()
        timerAuthView.setDeselectedUI()
    }
    
    /// view가 선택됐을 떄, view의 UI 변경
    private func setAuthViewState() {
        if photoOnly {
            photoAuthView.setSelectedUI()
            timerAuthView.setDeselectedUI()
        } else {
            photoAuthView.setDeselectedUI()
            timerAuthView.setSelectedUI()
        }
    }
    
    private func setGesture() {
        let photoTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        let timerTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        photoAuthView.addGestureRecognizer(photoTapGesture)
        timerAuthView.addGestureRecognizer(timerTapGesture)
    }
    
    private func setAddTarget() {
        enterButton.addTarget(self, action: #selector(touchEnterButton), for: .touchUpInside)
    }
    
    @objc
    private func touchEnterButton() {
        postCreateRoomWithAPI(roomName: roomName, fromStart: !photoOnly) {
            guard let rootVC = UIStoryboard(name: Const.Storyboard.Name.waiting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.waiting) as? WaitingVC else { return }
            rootVC.roomName = self.roomName
            rootVC.roomId = self.roomId
            
            let nextVC = UINavigationController(rootViewController: rootVC)
            nextVC.modalTransitionStyle = .crossDissolve
            nextVC.modalPresentationStyle = .fullScreen
            
            self.present(nextVC, animated: true)
        }
    }
    
    @objc
    private func tapped(_ gesture: UITapGestureRecognizer) {
        if photoOnly {
            photoOnly = false
        } else {
            photoOnly = true
        }
        setAuthViewState()
    }
    
    @objc
    private func popToCreateRoomVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Network
extension CreateAuthVC {
    func postCreateRoomWithAPI(roomName: String, fromStart: Bool, completion: @escaping () -> Void) {
        let createRoomRequest = CreateRoom(roomName: roomName, fromStart: fromStart)
        RoomAPI.shared.createRoom(createRoom: createRoomRequest) { response in
            switch response {
            case .success(let data):
                if let createdRoom = data as? RoomId {
                    self.roomId = createdRoom.roomID
                }
                completion()
            case .requestErr(let message):
                print("postCreateRoom - requestErr: \(message)")
            case .pathErr:
                print("postCreateRoom - pathErr")
            case .serverErr:
                print("postCreateRoom - serverErr")
            case .networkFail:
                print("postCreateRoom - networkFail")
            }
        }
    }
}

// MARK: - Layout
extension CreateAuthVC {
    private func setLayout() {
        view.addSubviews([titleLabel, subTitleLabel, photoAuthView, timerAuthView, enterButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(UIScreen.main.hasNotch ? 12 : 8)
            make.leading.equalToSuperview().inset(20)
        }
        
        photoAuthView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(UIScreen.main.hasNotch ? 206 : 180)
        }
        
        timerAuthView.snp.makeConstraints { make in
            make.top.equalTo(photoAuthView.snp.bottom).offset(UIScreen.main.hasNotch ? 16 : 12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(UIScreen.main.hasNotch ? 206 : 180)
        }
        
        enterButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(self.view.frame.width*48/335)
        }
    }
}
