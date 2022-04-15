//
//  CreateAuthVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/01/14.
//

import UIKit

import SnapKit
import Lottie

class CreateAuthVC: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let photoAuthView = PhotoAuthView()
    private let timerAuthView = TimerAuthView()
    private let createButton = BottomButton().setUI(.pink).setTitle("습관방 만들기")
    private let customNavigationBar = LeftButtonNavigaitonBar()
    
    /// photoOnly가 true이면 fromStart가 false
    var photoOnly: Bool = true
    var roomName: String = ""
    var roomId: Int?
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
        setAuthViewState()
        setGesture()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        customNavigationBar.title("")
            .leftButtonImage("icBackWhite")
            .leftButtonAction {
                self.popToCreatRoomVC()
            }
        
        titleLabel.text = "어떻게 습관을 인증할까요?"
        titleLabel.font = .h2Title
        titleLabel.textColor = .sparkBlack
        
        subTitleLabel.text = "습관 유형에 알맞는 인증 방식을\n선택해 주세요."
        subTitleLabel.numberOfLines = 2
        subTitleLabel.font = .krRegularFont(ofSize: 18)
        subTitleLabel.textColor = .sparkDarkGray
        
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
        let photoTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTapped(_:)))
        let timerTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(timerTapped(_:)))
        photoAuthView.addGestureRecognizer(photoTapGesture)
        timerAuthView.addGestureRecognizer(timerTapGesture)
    }
    
    private func setAddTarget() {
        createButton.addTarget(self, action: #selector(touchCreateButton), for: .touchUpInside)
    }
    
    @objc
    private func touchCreateButton() {
        guard let dialogVC = UIStoryboard(name: Const.Storyboard.Name.dialogue, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.dialogue) as? DialogueVC else { return }
        
        dialogVC.dialogueType = .createRoom
        dialogVC.clousure = {
            self.postCreateRoomWithAPI(roomName: self.roomName, fromStart: !self.photoOnly) {
                guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.createSuccess, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.createSuccess) as? CreateSuccessVC else { return }
                
                nextVC.roomName = self.roomName
                nextVC.roomId = self.roomId

                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        dialogVC.modalPresentationStyle = .overFullScreen
        dialogVC.modalTransitionStyle = .crossDissolve
        present(dialogVC, animated: true, completion: nil)
    }
    
    @objc
    private func photoTapped(_ gesture: UITapGestureRecognizer) {
        if !photoOnly {
            photoOnly = true
        }
        setAuthViewState()
    }
    
    @objc
    private func timerTapped(_ gesture: UITapGestureRecognizer) {
        if photoOnly {
            photoOnly = false
        }
        setAuthViewState()
    }
    
    // MARK: - Screen Change
    
    private func popToCreatRoomVC() {
        navigationController?.popViewController(animated: true)
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
        RoomAPI(viewController: self).createRoom(createRoom: createRoomRequest) { response in
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
        view.addSubviews([customNavigationBar, titleLabel, subTitleLabel, photoAuthView, timerAuthView, createButton])
        
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(12)
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
        
        createButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
