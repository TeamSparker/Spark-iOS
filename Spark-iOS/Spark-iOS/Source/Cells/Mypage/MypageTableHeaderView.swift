//
//  MypageTableHeaderView.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/03.
//

import UIKit

import SnapKit

class MypageTableHeaderView: UIView {
    
    // MARK: - Properties
    
    private let headerTitleLabel = UILabel()
    
    // MARK: - View Life Cycle
    
    init(type: MypageTableSection) {
        super.init(frame: .zero)
        
        switch type {
        case .profile:
            headerTitleLabel.text = ""
        case .setting:
            headerTitleLabel.text = "설정"
        case .center:
            headerTitleLabel.text = "고객센터"
        case .service:
            headerTitleLabel.text = "서비스"
        }
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MypageTableHeaderView {
    private func setUI() {
        headerTitleLabel.font = .p2Subtitle
        headerTitleLabel.textColor = .darkGray
    }
    
    private func setLayout() {
        self.addSubview(headerTitleLabel)
        
        headerTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
