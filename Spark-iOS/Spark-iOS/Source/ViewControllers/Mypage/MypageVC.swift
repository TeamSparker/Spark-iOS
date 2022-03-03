//
//  MypageVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/03.
//

import UIKit

import SnapKit

@frozen
public enum MypageRow: Int, CaseIterable {
    case profile // 프로필
    case contact // 문의하기
    case sparkGuide // 스파크 사용 가이드
    case tos // Terms of service terms of use. 약관 및 정책
    case version // 버전 정보
    case logout // 로그아웃
    case withdrawal // 회원 탈퇴
}

class MypageVC: UIViewController {

    // MARK: - Properties
    
    private let customNavigationBar = LeftButtonNavigaitonBar()
    private let tableView = UITableView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setTableView()
    }
}

// MARK: - Extension

extension MypageVC {
    private func setUI() {
        customNavigationBar.title("MY")
            .font(.h3SubtitleEng)
            .leftButtonImage("icBackWhite")
            .leftButonAction {
                self.dismiss(animated: true, completion: nil)
            }
    }
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // TODO: - cell register.
//        tableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: )
        
        tableView.showsVerticalScrollIndicator = false
    }
}

// MARK: - UITableViewDelegate

extension MypageVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension MypageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellWidth = tableView.frame.width
        let profileCellHeight = cellWidth * (125 / 375)
        let defaultCellHeight = cellWidth * (40 / 375)
        let withdrawalCellHeight = cellWidth * (81 / 375)
        
        guard let row = MypageRow(rawValue: indexPath.row) else { return 0 }
        switch row {
        case .profile:
            return profileCellHeight
        case .contact, .sparkGuide, .tos, .version, .logout:
            return defaultCellHeight
        case .withdrawal:
            return withdrawalCellHeight
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MypageRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = MypageRow(rawValue: indexPath.row) else { return UITableViewCell() }
        // TODO: - set cell.
//        switch row {
//        case .profile:
//            <#code#>
//        case .contact:
//            <#code#>
//        case .sparkGuide:
//            <#code#>
//        case .tos:
//            <#code#>
//        case .version:
//            <#code#>
//        case .logout:
//            <#code#>
//        case .withdrawal:
//            <#code#>
//        }
//    }
}

// MARK: - Layout

extension MypageVC {
    private func setLayout() {
        view.addSubviews([customNavigationBar, tableView])
        
        customNavigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
