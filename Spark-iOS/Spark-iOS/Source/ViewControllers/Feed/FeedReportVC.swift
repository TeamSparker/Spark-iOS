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
    private let placeHolder: String = "해당 게시글을 신고하는 이유에 대해\n구체적으로 작성해주세요. (최대 150자)"
    private let maxLength: Int = 150
    
    private var customNavigationBar = LeftButtonNavigaitonBar()
    
    var recordID: Int?
    var didReport: Bool?
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setLayout()
        setPlaceHolder()
        setDelegate()
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBar()
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
        
        reportTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    private func setPlaceHolder() {
        reportTextView.text = placeHolder
        reportTextView.textColor = .sparkGray
        reportTextView.font = .p1TitleLight
        reportTextView.layer.borderColor = UIColor.sparkGray.cgColor
    }
    
    private func setDelegate() {
        reportTextView.delegate = self
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        
        customNavigationBar.title("게시물 신고")
            .leftButtonImage("icBackWhite")
            .leftButtonAction {
                self.popToFeedVC()
            }
    }
    
    private func setTabBar() {
        guard let tabBarController = tabBarController as? SparkTabBarController else { return }
        tabBarController.sparkTabBar.isHidden = true
    }
    
    private func setAddTarget() {
        reportButton.addTarget(self, action: #selector(touchReportButton), for: .touchUpInside)
    }
    
    private func popToFeedVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func postNotification() {
        NotificationCenter.default.post(name: .feedReport, object: nil)
    }
    
    // MARK: - @objc
    
    @objc
    func touchReportButton() {
        postFeedReportWithAPI(content: reportTextView.text ?? "")
    }
}

extension FeedReportVC: UITextViewDelegate {
    // 여백 클릭 시
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 입력 시작
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeHolder {
            reportTextView.layer.borderColor = UIColor.sparkDarkPinkred.cgColor
            reportTextView.text = ""
            reportTextView.textColor = .sparkBlack
        } else {
            
        }
        return true
    }
    
    // 입력 끝
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.hasText {
            if textView.text == placeHolder {
                reportButton.setDisable()
            } else {
                reportButton.setAble()
            }
        } else {
            reportButton.setDisable()
            setPlaceHolder()
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let text = textView.text {
            if text.count >= maxLength {
                let maxIndex = text.index(text.startIndex, offsetBy: maxLength)
                let newString = String(text[text.startIndex..<maxIndex])
                textView.text = newString
            }
        }
    }
}

// MARK: - Network

extension FeedReportVC {
    func postFeedReportWithAPI(content: String) {
        FeedAPI(viewController: self).postFeedReport(recordID: recordID ?? 0, content: content) { response in
            switch response {
            case .success:
                self.navigationController?.popViewController(animated: true)
                self.postNotification()
            case .requestErr(let message):
                print("postFeedReportWithAPI - requestErr: \(message)")
            case .pathErr:
                print("postFeedReportWithAPI - pathErr")
            case .serverErr:
                print("postFeedReportWithAPI - serverErr")
            case .networkFail:
                print("postFeedReportWithAPI - networkFail")
            }
        }
    }
}

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

extension FeedReportVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
