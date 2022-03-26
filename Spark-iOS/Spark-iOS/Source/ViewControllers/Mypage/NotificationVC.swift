//
//  NotificationVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/27.
//

import UIKit

import SnapKit

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
        
        tableView.register(NotificationHeaderTVC.self, forCellReuseIdentifier: Const.Cell.Identifier.notificationHeaderTVC)
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
    
}

// MARK: - UITableViewDataSource

extension NotificationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
