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
        
        print("Zsssgljaljl")
        setNavigationBar()
        setUI()
        setLayout()
        setPlaceHolder()
    }
    
    // MARK: - Method
    
    private func setUI() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        titleLabel.text = "신고 이유에 대해 알려주세요."
        describeLabel.text = "신고 전 잠깐!"
        subDescribeLabel.text = """
        - 신고하신 내용은 서비스 운영 정책에 따라 처리됩니다.
        - 타당한 근거 없이 신고된 내용은 반영되지 않을 수 \n있습니다.
        """
        subDescribeLabel.numberOfLines = 3
        
        titleLabel.font = .h2Title
        describeLabel.font = .p2Subtitle
        subDescribeLabel.font = .p2Subtitle
        
        titleLabel.textColor = .sparkBlack
        describeLabel.textColor = .sparkDarkGray
        subDescribeLabel.textColor = .sparkDarkGray
        
        reportTextView.layer.cornerRadius = 2
        reportTextView.layer.borderWidth = 1
        reportTextView.layer.borderColor = UIColor.sparkDarkPinkred.cgColor
        
        reportTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    private func setPlaceHolder() {
        reportTextView.text = """
        해당 게시글을 신고하는 이유에 대해
        구체적으로 작성해주세요. (최대 150자)
        """
        reportTextView.textColor = .sparkGray
        reportTextView.font = .p1TitleLight
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        
        customNavigationBar.title("게시물 신고")
            .leftButtonImage("icBackWhite")
            .leftButonAction {
                self.popToFeedVC()
            }
    }
    
    private func popToFeedVC() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - @objc

}

// MARK: - Network

// MARK: - Layout

extension FeedReportVC {
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
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(reportButton.snp.top).offset(-44)
        }
        
        describeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(subDescribeLabel.snp.top).offset(-12)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
// FIXME: - 네비게이션 extension 정리후 공통으로 빼서 사용하기
extension FeedReportVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
