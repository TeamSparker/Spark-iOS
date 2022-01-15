//
//  AuthUploadVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/16.
//

import UIKit

class AuthUploadVC: UIViewController {

    @IBOutlet weak var uploadImageView: UIImageView!
    
    var vcType: VCCase = .cameraTimer
    
    var uploadImageView = UIImageView()
    var uploadImage = UIImage()
    
    var buttonStackView = UIStackView()
    var uploadButton = UIButton()
    var retakeButton = UIButton()
    
    var timerLabel = UILabel()
    var uploadImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
extension AuthUploadVC {
    func setUI() {
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
        retakeButton.layer.borderWidth = 1
        retakeButton.layer.borderColor = .init(red: 1, green: 0, blue: 61/255, alpha: 1)
        retakeButton.isEnabled = true
        
        uploadButton.layer.cornerRadius = 2
        uploadButton.titleLabel?.font = .btn1Default
        uploadButton.setTitle("업로드", for: .normal)
        uploadButton.backgroundColor = .sparkDarkPinkred
        uploadButton.isEnabled = true
        uploadImageView.image = uploadImage
    func setLayout() {
        view.addSubviews([uploadImageView, buttonStackView, timerLabel])
        
        uploadImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(220)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(uploadImageView.snp.bottom).offset(117)
            make.bottom.equalToSuperview().inset(54)
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
    
    func setStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .equalSpacing
        buttonStackView.spacing = 15
        buttonStackView.addArrangedSubview(retakeButton)
        buttonStackView.addArrangedSubview(uploadButton)
    }
}
