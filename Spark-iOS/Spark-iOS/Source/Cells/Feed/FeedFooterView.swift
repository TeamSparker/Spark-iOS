//
//  FeedFooterView.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/02/02.
//

import UIKit

import SnapKit
import Lottie

class FeedFooterView: UICollectionReusableView {
        
    // MARK: - Properties
    private let footerLabel = UILabel()
    private let loadingView = AnimationView(name: Const.Lottie.Name.loading)
    
    // MARK: - View Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.backgroundColor = .sparkWhite
        footerLabel.text = "최근 일주일 간의 인증만 보여집니다⚡️"
        footerLabel.textColor = .sparkGray
        footerLabel.font = .krRegularFont(ofSize: 16)
        
        loadingView.isHidden = true
        loadingView.loopMode = .loop
        loadingView.contentMode = .scaleAspectFit
    }
    
    private func setLayout() {
        self.addSubviews([footerLabel, loadingView])
        
        footerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
        }
    }
    
    func playLoading() {
        footerLabel.isHidden = true
        loadingView.isHidden = false
        loadingView.play()
    }
    
    func stopLoading() {
        footerLabel.isHidden = false
        loadingView.isHidden = true
    }
}
