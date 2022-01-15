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
    var photoOnly: Bool = true /// 사진 인증만
    var roomName: String = ""

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
        navigationController?.initWithTitle(title: "", tintColor: .sparkBlack, backgroundColor: .sparkWhite)
        
        titleLabel.text = "어떻게 습관을 인증할까요?"
        titleLabel.font = .h2Title
        titleLabel.textColor = .sparkBlack
        
        subTitleLabel.text = "66일간의 습관에 알맞는 인증 방식을 \n선택해주세요."
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
    
    private func setLayout() {
        view.addSubviews([titleLabel, subTitleLabel, photoAuthView, timerAuthView, enterButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        photoAuthView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(206)
        }
        
        timerAuthView.snp.makeConstraints { make in
            make.top.equalTo(photoAuthView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(206)
        }
        
        enterButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(self.view.frame.width*48/335)
        }
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
        let timerTapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        photoAuthView.addGestureRecognizer(photoTapGesture)
        timerAuthView.addGestureRecognizer(timerTapGesture)
    }
    
    private func setAddTarget() {
        enterButton.addTarget(self, action: #selector(touchEnterButton), for: .touchUpInside)
    }
    
    @objc
    func touchEnterButton() {
        guard let rootVC = UIStoryboard(name: Const.Storyboard.Name.waiting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.waiting) as? WaitingVC else { return }
        
        let nextVC = UINavigationController(rootViewController: rootVC)
        
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .fullScreen
        rootVC.photoOnly = photoOnly
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc
    func tapped(_ gesture: UITapGestureRecognizer) {
        if photoOnly {
            photoOnly = false
        } else {
            photoOnly = true
        }
        setAuthViewState()
    }
}
