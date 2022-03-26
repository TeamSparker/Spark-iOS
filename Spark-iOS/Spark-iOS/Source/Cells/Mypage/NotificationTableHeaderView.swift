//
//  NotificationHeaderTVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/27.
//

import UIKit

class NotificationTableHeaderView: UIView {
    
    // MARK: - Properties
    
    private let headerTitleLabel = UILabel()
    
    // MARK: - View Life Cycle
    
    init(type: NotificationTableSection) {
        super.init(frame: .zero)
        
        switch type {
        case .information:
            headerTitleLabel.text = "안내"
        case .sparkerActivity:
            headerTitleLabel.text = "스파커 활동"
        case .remind:
            headerTitleLabel.text = "리마인드"
        }
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationTableHeaderView {
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
