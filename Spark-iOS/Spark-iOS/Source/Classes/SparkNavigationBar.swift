//
//  SparkNavigationBar.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/02/17.
//

import Foundation
import UIKit

import SnapKit

class SparkNavigationBar: UIView {
    
    // MARK: - Properties
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = ""
        label.textColor = .sparkBlack
        label.font = .h3Subtitle
        
        return label
    }()
    
    // MARK: - Initialize
    
    // 코드베이스
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    // 스토리보드
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setUI()
        setLayout()
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.backgroundColor = .sparkWhite
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    /// set text of title label.
    /// - default label text is empty.
    @discardableResult
    func setTitle(_ title: String) -> Self {
        titleLabel.text = title
        
        return self
    }
    
    /// set color of title label.
    /// - default color is sparkBlack.
    @discardableResult
    func setTitleColor(_ color: UIColor) -> Self {
        self.titleLabel.textColor = color
        
        return self
    }

    /// set font of title lable.
    /// - default font is h3_subtitle.
    @discardableResult
    func setFont(_ font: UIFont) -> Self {
        self.titleLabel.font = font
        
        return self
    }
    
    /// set background color of custom navigation bar.
    /// - default background color is sparkWhite.
    @discardableResult
    func setBackgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        
        return self
    }
}
