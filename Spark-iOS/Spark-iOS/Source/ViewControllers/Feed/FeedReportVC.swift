//
//  FeedReportVC.swift
//  Spark-iOS
//
//  Created by 양수빈 on 2022/03/06.
//

import UIKit

import SnapKit

class FeedReportVC: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let reportTextView = UITextView()
    private let describeLabel = UILabel()
    private let subDescribeLabel = UILabel()
    private let reportButton = BottomButton().setUI(.pink).setTitle("신고하기").setDisable()
    
    private var customNavigationBar = LeftButtonNavigaitonBar()
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setLayout()
    }
    
    // MARK: - Method
    
    private func setLayout() {
        view.addSubviews([customNavigationBar, titleLabel, reportTextView,
                          describeLabel, subDescribeLabel, reportButton])
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(customNavigationBar.snp.bottom).offset(24)
        }
        
        reportTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.height.equalTo(225)
        }
        
        reportButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        subDescribeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(reportButton.snp.top).inset(44)
        }
        
        describeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(subDescribeLabel.snp.top).inset(12)
        }
    }
    
    private func setUI() {
        titleLabel.text = "신고 이유에 대해 알려주세요."
        reportTextView.backgroundColor = .sparkDarkPinkred
        
        describeLabel.text = "신고 전 잠깐!"
        subDescribeLabel.text = """
        - 신고하신 내용은 서비스 운영 정책에 따라 처리됩니다.
        - 타당한 근거 없이 신고된 내용은 반영되지 않을 수 있습니다.
        """
        subDescribeLabel.numberOfLines = 3
        
        titleLabel.font = .h2Title
        describeLabel.font = .p2Subtitle
        subDescribeLabel.font = .p2Subtitle
    }
    
    private func setNavigationBar() {
        customNavigationBar.title("게시물 신고")
            .leftButtonImage("icBackWhite")
            .leftButonAction {
                self.navigationController?.popToViewController(self, animated: true)
            }
    }
    
    // MARK: - @objc

}

// MARK: - Network

// MARK: - Layout

extension FeedReportVC {
    
}
