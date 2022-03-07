//
//  NoticeHeaderView.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/06.
//

import UIKit

import SnapKit

class NoticeHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    private let sparkerButton = UIButton()
    private let noticeButton = UIButton()
    
    // MARK: - Life Cycles
    
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
        
    }
    
    private func setLayout() {
        
    }
    
    // TODO: - 베지어패스 그려줌과 동시에 컬러 변경해주는 함수
    
}
