//
//  MypageVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/03.
//

import UIKit

import SnapKit

@frozen
public enum MypageRow: Int {
    case profile // 프로필
    case notification // 알림
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
    
    @frozen
    private enum Section: Int, CaseIterable {
        case profile
        case setting
        case center
        case service
    }
    
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
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .appearFloatingButton, object: nil)
            }
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        tabBarController?.tabBar.isHidden = true
        
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
    }
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MypageProfileTVC.self, forCellReuseIdentifier: Const.Cell.Identifier.mypageProfileTVC)
        tableView.register(MypageDefaultTVC.self, forCellReuseIdentifier: Const.Cell.Identifier.mypageDefaultTVC)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
}

// MARK: - UITableViewDelegate

extension MypageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 32
        } else {
            return 28
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택시 회색으로 변했다가 돌아옴.
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellWidth = tableView.frame.width
        let profileCellHeight = cellWidth * (125 / 375)
        let defaultCellHeight = cellWidth * (48 / 375)
        let withdrawalCellHeight = cellWidth * (81 / 375)
        
        if indexPath.section == 0 {
            return profileCellHeight
        } else {
            if indexPath.row == 4 {
                return withdrawalCellHeight
            } else {
                return defaultCellHeight
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MypageVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowOfSection: [MypageRow]
        if section == 0 {
            rowOfSection = [.profile]
            
            return rowOfSection.count
        } else if section == 1 {
            rowOfSection = [.notification]
            
            return rowOfSection.count
        } else if section == 2 {
            rowOfSection = [.contact]
            
            return rowOfSection.count
        } else if section == 3 {
            rowOfSection = [.sparkGuide, .tos, .version, .logout, .withdrawal]
            
            return rowOfSection.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cell.Identifier.mypageProfileTVC, for: indexPath) as? MypageProfileTVC else { return UITableViewCell()}
            cell.initCell(profile: "", nickname: "하양")
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cell.Identifier.mypageDefaultTVC, for: indexPath) as? MypageDefaultTVC else { return UITableViewCell()}
            cell.initCell(type: .notification)
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cell.Identifier.mypageDefaultTVC, for: indexPath) as? MypageDefaultTVC else { return UITableViewCell()}
            cell.initCell(type: .contact)
            cell.selectionStyle = .none
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cell.Identifier.mypageDefaultTVC, for: indexPath) as? MypageDefaultTVC else { return UITableViewCell()}
            
            // MypageRow(rawValue: 3) = .sparkGuide
            // MypageRow(rawValue: 4) = .tos
            // MypageRow(rawValue: 6) = .logout
            guard let row = MypageRow(rawValue: indexPath.section + indexPath.row) else { return UITableViewCell() }
                    cell.initCell(type: row)
            
            // MypageRow(rawValue: 5) = .version
            if indexPath.row == 2 {
                cell.isUserInteractionEnabled = false
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

// MARK: - Network

extension MypageVC {
    // TODO: - 서버통신.
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

// MARK: - UIGestureRecognizerDelegate
// FIXME: - 네비게이션 extension 정리후 공통으로 빼서 사용하기
extension MypageVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
