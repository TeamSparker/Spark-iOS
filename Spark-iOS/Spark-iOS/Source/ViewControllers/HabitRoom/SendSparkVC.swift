//
//  SendSparkVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/18.
//

import UIKit

class SendSparkVC: UIViewController {

    // MARK: Properties

    var roomID: Int?
    var recordID: Int?
    var userName: String?
    var profileImage: String?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 64/2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.sparkLightGray.cgColor
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .h3Subtitle
        label.textColor = .sparkLightGray
        return label
    }()
    
    private var buttonCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 124, height: 124)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.font = .p1TitleLight
        label.textColor = .sparkGray
        label.text = "메시지 선택 시 바로 보낼 수 있어요!"
        return label
    }()
    
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    
    // MARK: IBoutlet properties
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCollectionView()
        setLayout()
        setAddTargets()
    }
    
    // MARK: IBAction Properties
    
    @IBAction func touchOutsideButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: Methods

extension SendSparkVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        tabBarController?.tabBar.isHidden = true
        
        profileImageView.updateImage(profileImage ?? "")
        
        userNameLabel.text = "\(userName ?? "")에게"
    }
    
    private func setCollectionView() {
        buttonCV.delegate = self
        buttonCV.dataSource = self
        buttonCV.register(SendSparkCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.sendSparkCVC)
    }
    
    private func setAddTargets() {
//        [firstButton, secondButton, thirdButton, fourthButton].forEach {
//            $0.addTarget(self, action: #selector(touchSendSparkButton(_:)), for: .touchUpInside)
//        }
    }
    
    private func setFeedbackGenerator() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.selectionChanged()
    }
    
    // MARK: - @objc Function
    
    @objc
    func touchSendSparkButton(_ sender: SendSparkButton) {
//        setFeedbackGenerator()
//
//        [firstButton, secondButton, thirdButton, fourthButton].forEach {
//            if $0.tag == sender.tag {
//                $0.isSelected(true)
//            } else {
//                // 통신실패 시에도 다시금 deselected 되야하니 필요함.
//                $0.isSelected(false)
//            }
//        }
//        let selectedMessage = sender.titleLabel?.text ?? ""
//        sendSparkWithAPI(content: selectedMessage)
    }
}

// MARK: - UICollectionViewDataSource

extension SendSparkVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.sendSparkCVC, for: indexPath) as? SendSparkCVC else { return UICollectionViewCell() }
        
        cell.setSparkButton(type: SendSparkStatus.init(rawValue: indexPath.row) ?? .message)
        
//        let name = members[indexPath.item].nickname
//        let imagePath = members[indexPath.item].profileImg ?? ""
//
//        cell.initCell(name: name, imagePath: imagePath)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SendSparkVC: UICollectionViewDelegate {

}

// MARK: Network

extension SendSparkVC {
    func sendSparkWithAPI(content: String) {
        RoomAPI.shared.sendSpark(roomID: roomID ?? 0, recordID: recordID ?? 0, content: content) {  response in
            switch response {
            case .success:
                let presentVC = self.presentingViewController
                self.dismiss(animated: true) {
                    presentVC?.showSparkToast(x: 20, y: 44, message: "\(self.userName ?? "")에게 스파크를 보냈어요!")
                }
            case .requestErr(let message):
                print("sendSparkWithAPI - requestErr: \(message)")
            case .pathErr:
                print("sendSparkWithAPI - pathErr")
            case .serverErr:
                print("sendSparkWithAPI - serverErr")
            case .networkFail:
                print("sendSparkWithAPI - networkFail")
            }
        }
    }
}

// MARK: - Layout

extension SendSparkVC {
    private func setLayout() {
        view.addSubviews([profileImageView, userNameLabel, buttonCV, guideLabel])
        
        profileImageView.snp.makeConstraints { make in
            make.bottom.equalTo(userNameLabel.snp.top).offset(-12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(buttonCV.snp.top).offset(-200)
            make.centerX.equalToSuperview()
        }
        
        buttonCV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(87)
            make.height.equalTo(124)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(44)
            make.centerX.equalToSuperview()
        }
    }
}
