//
//  LoginVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/12.
//

import AuthenticationServices
import SafariServices
import UIKit

import FirebaseAnalytics
import KakaoSDKUser

class LoginVC: UIViewController {

    // MARK: - Properties
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setGetstureRecognizer()
        tracking()
    }
    
    // MARK: - @IBOutlet Action
    
    @IBAction func touchAppleLoginButton(_ sender: Any) {
        signupWithApple()
    }
    
    @IBAction func touchKakaoLoginButton(_ sender: Any) {
        signupWithKakao()
    }
}

// MARK: - Methods

extension LoginVC {
    private func setUI() {
        loginLabel.textColor = .sparkWhite
        loginLabel.font = .krMediumFont(ofSize: 12)
        let guideText = "로그인 시 이용약관과 개인정보 처리 방침에 동의하게 됩니다."
        let attributeString = NSMutableAttributedString(string: guideText)
        attributeString.addAttribute(.underlineStyle, value: 1, range: (guideText as NSString).range(of: "이용약관"))
        attributeString.addAttribute(.underlineStyle, value: 1, range: (guideText as NSString).range(of: "개인정보 처리 방침"))
        loginLabel.attributedText = attributeString
        loginLabel.isUserInteractionEnabled = true
        
        kakaoLoginButton.setImage(UIImage(named: "btnKakaoLogin"), for: .normal)
        appleLoginButton.setImage(UIImage(named: "btnAppleLogin"), for: .normal)
    }
    
    private func setGetstureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapLoginLabel(_:)))
        loginLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    private func tapLoginLabel(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: loginLabel)
        
        if let termsOfUseRect = loginLabel.rectFromString(with: "이용약관"), termsOfUseRect.contains(point) {
            let safariVC = SFSafariViewController(url: URL(string: Const.URL.termsOfUse)!)
            safariVC.transitioningDelegate = self
            safariVC.modalPresentationStyle = .pageSheet
            
            present(safariVC, animated: true)
        }
        
        if let privatePolicyRect = loginLabel.rectFromString(with: "개인정보 처리 방침"), privatePolicyRect.contains(point) {
            let safariVC = SFSafariViewController(url: URL(string: Const.URL.privatePolicy)!)
            safariVC.transitioningDelegate = self
            safariVC.modalPresentationStyle = .pageSheet
            
            present(safariVC, animated: true)
        }
    }
    
    private func signupWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func signupWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoApp()
        } else {
            loginWithWeb()
        }
    }
    
    private func loginWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk { _, error in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoApp() success.")
                
                self.getUserID()
            }
        }
    }
    
    private func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount { _, error in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                
                self.getUserID()
            }
        }
    }
    
    private func getUserID() {
        UserApi.shared.me {(user, error) in
            if let error = error {
                print(error)
            } else {
                if let userID = user?.id {
                    UserDefaultsManager.userID = String(userID)
                    UserDefaultsManager.isAppleLogin = false
                    
                    self.loginWithAPI(userID: String("Kakao@\(userID)"))
                }
            }
        }
    }
    
    private func presentToMainTBC() {
        guard let mainVC = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar) as? MainTBC else { return }
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        
        present(mainVC, animated: true, completion: nil)
    }
    
    private func tracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.View.viewSocialSignup
                           ])
    }
}

// MARK: - AppleSignIn

extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            
            UserDefaultsManager.userID = userIdentifier
            UserDefaultsManager.isAppleLogin = true
            
            loginWithAPI(userID: "Apple@\(userIdentifier)")
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

// MARK: - Network

extension LoginVC {
    private func loginWithAPI(userID: String) {
        AuthAPI(viewController: self).login(socialID: userID, fcmToken: UserDefaultsManager.fcmToken ?? "") { response in
            switch response {
            case .success(let data):
                if let data = data as? Login {
                    if data.isNew {
                        // 회원가입을 하지 않은 사용자입니다.
                        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.profileSetting, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.profileSetting) as? ProfileSettingVC else { return }
                        
                        nextVC.modalPresentationStyle = .fullScreen
                        
                        self.present(nextVC, animated: true, completion: nil)
                    } else {
                        // 회원 정보를 불러왔습니다.
                        UserDefaultsManager.accessToken = data.accesstoken
                        
                        self.presentToMainTBC()
                    }
                }
            case .requestErr(let message):
                print("loginWithAPI - requestErr: \(message)")
            case .pathErr:
                print("loginWithAPI - pathErr")
            case .serverErr:
                print("loginWithAPI - serverErr")
            case .networkFail:
                print("loginWithAPI - networkFail")
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension LoginVC: UIViewControllerTransitioningDelegate { }
