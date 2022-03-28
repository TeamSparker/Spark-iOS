//
//  NotificationVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/27.
//

import UIKit

import SnapKit

@frozen
public enum NotificationTableSection: Int, CaseIterable {
    case information
    case sparkerActivity
    case remind
}

@frozen
public enum NotificationTableRow: Int {
    case roomStart      // 습관방 시작
    case spark          // 스파크 보내기
    case consider       // 고민중
    case certification  // 인증 완료
    case remind         // 미완료 습관방
}

class NotificationVC: UIViewController {
    
    // MARK: - Properties
    
    private let customNavigationBar = LeftButtonNavigaitonBar()
    private let tableView = UITableView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTableView()
        setLayout()
    }
}

// MARK: - Extension

extension NotificationVC {
    private func setUI() {
        customNavigationBar.title("알림")
            .leftButtonImage("icBackWhite")
            .leftButtonAction {
                self.navigationController?.popViewController(animated: true)
            }
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(NotificationTVC.self, forCellReuseIdentifier: Const.Cell.Identifier.notificationTVC)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        // iOS 15.0 이상에서 section header 상단에 간격이 생겨서 삭제.
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
}

// MARK: - UITableViewDelegate

extension NotificationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = NotificationTableSection(rawValue: indexPath.section) else { return 0}
        switch section {
        case .information:
            return 84
        case .sparkerActivity, .remind:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = NotificationTableSection(rawValue: section) else { return UIView() }
        switch section {
        case .information:
            return NotificationTableHeaderView(type: .information)
        case .sparkerActivity:
            return NotificationTableHeaderView(type: .sparkerActivity)
        case .remind:
            return NotificationTableHeaderView(type: .remind)
        }
    }
}

// MARK: - UITableViewDataSource

extension NotificationVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return NotificationTableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowOfSection: [NotificationTableRow]
        guard let section = NotificationTableSection(rawValue: section) else { return 0 }
        switch section {
        case .information:
            rowOfSection = [.roomStart]
            
            return rowOfSection.count
        case .sparkerActivity:
            
            rowOfSection = [.spark, .consider, .certification]
            
            return rowOfSection.count
        case .remind:
            
            rowOfSection = [.remind]
            
            return rowOfSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = NotificationTableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cell.Identifier.notificationTVC, for: indexPath) as? NotificationTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        switch section {
        case .information:
            cell.initCell(with: .roomStart, isOn: false)
            
            return cell
        case .sparkerActivity:
            /*
             NotificationTableRow(rawValue: 1) 는 .spark 이다.
             NotificationTableRow(rawValue: 2) 는 .consider 이다.
             NotificationTableRow(rawValue: 3) 는 .certification 이다.
             */
            guard let row = NotificationTableRow(rawValue: indexPath.section + indexPath.row) else { return UITableViewCell() }
            cell.initCell(with: row, isOn: false)
            
            return cell
        case .remind:
            cell.initCell(with: .remind, isOn: false)
            
            return cell
        }
    }
}

// MARK: - Layout

extension NotificationVC {
    private func setLayout() {
        view.addSubviews([customNavigationBar, tableView])
        
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}