//
//  MypageVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/03/03.
//

import MessageUI
import SafariServices
import UIKit

import SnapKit

@frozen
public enum MypageTableRow: Int {
    case profile // 프로필
    case notification // 알림
    case contact // 문의하기
    case tos // Terms of service terms of use. 약관 및 정책
    case openSourceLibrary // 오픈소스 라이브러리
    case version // 버전 정보
    case logout // 로그아웃
    case withdrawal // 회원 탈퇴
}

@frozen
public enum MypageTableSection: Int, CaseIterable {
    case profile
    case setting
    case center
    case service
}

class MypageVC: UIViewController {

    // MARK: - Properties
    
    private let customNavigationBar = LeftButtonNavigaitonBar()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private var profileImage: UIImage?
    private var profileNickname: String?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setTableView()
        profileFetchWithAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBar()
        setFloatingButton()
    }
}

// MARK: - Extension

extension MypageVC {
    private func setUI() {
        customNavigationBar.title("MY")
            .font(.h3SubtitleEng)
            .leftButtonImage("icBackWhite")
            .leftButtonAction {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .appearFloatingButton, object: nil)
            }
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setTabBar() {
        guard let tabBarController = tabBarController as? SparkTabBarController else { return }
        tabBarController.sparkTabBar.isHidden = true
    }
    
    private func setFloatingButton() {
        NotificationCenter.default.post(name: .disappearFloatingButton, object: nil)
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = .sparkWhite
        
        tableView.register(MypageProfileTVC.self, forCellReuseIdentifier: Const.Cell.Identifier.mypageProfileTVC)
        tableView.register(MypageDefaultTVC.self, forCellReuseIdentifier: Const.Cell.Identifier.mypageDefaultTVC)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        // iOS 15.0 이상에서 section header 상단에 간격이 생겨서 삭제.
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
}

// MARK: - UITableViewDelegate

extension MypageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = MypageTableSection(rawValue: section) else { return 0 }
        switch section {
        case .profile:
            return 0
        case .setting:
            return 53
        case .center, .service:
            return 49
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = MypageTableSection(rawValue: section) else { return UIView() }
        switch section {
        case .profile:
            return MypageTableHeaderView(type: .profile)
        case .setting:
            return MypageTableHeaderView(type: .setting)
        case .center:
            return MypageTableHeaderView(type: .center)
        case .service:
            return MypageTableHeaderView(type: .service)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MypageTableSection(rawValue: indexPath.section) else { return }
        switch section {
        case .profile:
            guard let editProfileVC = UIStoryboard(name: Const.Storyboard.Name.editProfile, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.editProfile) as? EditProfileVC else { return }

            editProfileVC.profileImage = profileImage
            editProfileVC.nickname = profileNickname
            editProfileVC.profileImageDelegate = self
            editProfileVC.modalPresentationStyle = .overFullScreen
            present(editProfileVC, animated: true, completion: nil)
        case .setting:
            guard let notificationVC = UIStoryboard(name: Const.Storyboard.Name.notification, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.notification) as? NotificationVC else { return }
            
            navigationController?.pushViewController(notificationVC, animated: true)
        case .center:
            if MFMailComposeViewController.canSendMail() {
                guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
                
                let mailComposeVC = MFMailComposeViewController()
                mailComposeVC.mailComposeDelegate = self
                
                mailComposeVC.setToRecipients(["teamsparker66@gmail.com"])
                mailComposeVC.setSubject("스파크 문의 사항")
                mailComposeVC.setMessageBody("""
                
                Device : \(UIDevice.iPhoneModel)
                OS Version : \(UIDevice.iOSVersion)
                App Version : \(appVersion)
                --------------------
                
                
                문의 사항을 상세히 입력해주세요.
                """,
                                             isHTML: false)
        
                present(mailComposeVC, animated: true, completion: nil)
            } else {
                // 메일이 계정과 연동되지 않은 경우.
                let mailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in }
                mailErrorAlert.addAction(confirmAction)
                present(mailErrorAlert, animated: true, completion: nil)
            }
        case .service:
            if indexPath.row == 0 {
                // 약관 및 정책
                guard let url = URL(string: Const.URL.tosURL) else { return }
                let safariVC = SFSafariViewController(url: url)
                safariVC.transitioningDelegate = self
                safariVC.modalPresentationStyle = .pageSheet
                
                present(safariVC, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                // 오픈소스 라이브러리
                guard let url = URL(string: Const.URL.openSourceLibraryURL) else { return }
                let safariVC = SFSafariViewController(url: url)
                safariVC.transitioningDelegate = self
                safariVC.modalPresentationStyle = .pageSheet
                
                present(safariVC, animated: true, completion: nil)
            } else if indexPath.row == 3 {
                // 로그아웃
                signoutWithAPI {
                    guard let loginVC = UIStoryboard(name: Const.Storyboard.Name.login, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.login) as? LoginVC else { return }
                    
                    loginVC.modalTransitionStyle = .crossDissolve
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: true) {
                        UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.accessToken)
                    }
                }
            }
        }
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
        return MypageTableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowOfSection: [MypageTableRow]
        guard let section = MypageTableSection(rawValue: section) else { return 0 }
        switch section {
        case .profile:
            rowOfSection = [.profile]
            
            return rowOfSection.count
        case .setting:
            rowOfSection = [.notification]
            
            return rowOfSection.count
        case .center:
            rowOfSection = [.contact]
            
            return rowOfSection.count
        case .service:
            rowOfSection = [.tos, .openSourceLibrary, .version, .logout, .withdrawal]
            
            return rowOfSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = MypageTableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cell.Identifier.mypageProfileTVC, for: indexPath) as? MypageProfileTVC else { return UITableViewCell()}
            cell.initCell(profileImage: profileImage, nickname: profileNickname)
            cell.selectionStyle = .none
            
            return cell
        case .setting:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cell.Identifier.mypageDefaultTVC, for: indexPath) as? MypageDefaultTVC else { return UITableViewCell()}
            cell.initCell(type: .notification)
            cell.selectionStyle = .none
            
            return cell
        case .center:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cell.Identifier.mypageDefaultTVC, for: indexPath) as? MypageDefaultTVC else { return UITableViewCell()}
            cell.initCell(type: .contact)
            cell.selectionStyle = .none
            
            return cell
        case .service:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cell.Identifier.mypageDefaultTVC, for: indexPath) as? MypageDefaultTVC else { return UITableViewCell()}
            
            /*
             MypageTableRow(rawValue: 3) 는 .tos 이다.
             MypageTableRow(rawValue: 4) 는 .openSourceLibrary 이다.
             MypageTableRow(rawValue: 5) 는 .version 이다.
             MypageTableRow(rawValue: 6) 는 .logout 이다.
             MypageTableRow(rawValue: 7) 는 .withdrawal 이다.
             */
            guard let row = MypageTableRow(rawValue: indexPath.section + indexPath.row) else { return UITableViewCell() }
            cell.initCell(type: row)
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

// MARK: - Network

extension MypageVC {
    private func profileFetchWithAPI() {
        UserAPI.shared.profileFetch { response in
            switch response {
            case .success(let data):
                if let profile = data as? Profile {
                    self.profileNickname = profile.nickname
                    
                    let imageView = UIImageView()
                    imageView.updateImage(profile.profileImage, type: .small)
                    self.profileImage = imageView.image
                    self.tableView.reloadData()
                }
            case .requestErr(let message):
                print("profileFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("profileFetchWithAPI - pathErr")
            case .serverErr:
                print("profileFetchWithAPI - serverErr")
            case .networkFail:
                print("profileFetchWithAPI - networkFail")
            }
        }
    }
    
    private func signoutWithAPI(completion: @escaping () -> Void) {
        AuthAPI.shared.signout { response in
            switch response {
            case .success(let message):
                completion()
                
                print("signoutWithAPI - success: \(message)")
            case .requestErr(let message):
                print("signoutWithAPI - requestErr: \(message)")
            case .pathErr:
                print("signoutWithAPI - pathErr")
            case .serverErr:
                print("signoutWithAPI - serverErr")
            case .networkFail:
                print("signoutWithAPI - networkFail")
            }
        }
    }
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

// MARK: - ProfileImageDelegate

extension MypageVC: ProfileImageDelegate {
    func sendProfile(image profileImage: UIImage, nickname: String) {
        self.profileImage = profileImage
        self.profileNickname = nickname
        tableView.reloadData()
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension MypageVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            controller.dismiss(animated: true) { print("mailComposeController - cancelled.")}
        case .saved:
            controller.dismiss(animated: true) { print("mailComposeController - saved.")}
        case .sent:
            controller.dismiss(animated: true) {
                self.showToast(x: 20, y: self.view.safeAreaInsets.top, message: "성공적으로 메일을 보냈어요!", font: .p1TitleLight)
            }
        case .failed:
            controller.dismiss(animated: true) { print("mailComposeController - filed.")}
        @unknown default:
            return
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MypageVC: UIViewControllerTransitioningDelegate { }

// MARK: - UIGestureRecognizerDelegate
// FIXME: - 네비게이션 extension 정리후 공통으로 빼서 사용하기
extension MypageVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

// MARK: - WithdrawalCellDelegate

extension MypageVC: WithdrawalCellDelegate {
    func withdrawalButtonTapped() {
        guard let withdrawalVC = UIStoryboard(name: Const.Storyboard.Name.withdrawal, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.withdrawal) as? WithdrawalVC else { return }
        
        navigationController?.pushViewController(withdrawalVC, animated: true)
    }
}
