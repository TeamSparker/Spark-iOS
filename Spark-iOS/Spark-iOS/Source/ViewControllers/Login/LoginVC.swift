//
//  LoginVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/12.
//

import AuthenticationServices
import UIKit

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
        loginLabel.text = "로그인 시 이용약관과 개인정보 처리 방침에 동의하게 됩니다."
        loginLabel.textColor = .sparkWhite
        
        loginLabel.font = .krMediumFont(ofSize: 12)
        
        kakaoLoginButton.setImage(UIImage(named: "btnKakaoLogin"), for: .normal)
        appleLoginButton.setImage(UIImage(named: "btnAppleLogin"), for: .normal)
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
                    self.signupWithAPI(userID: String(userID))
                    
                    UserDefaults.standard.set(String(userID), forKey: Const.UserDefaultsKey.userID)
                    UserDefaults.standard.set(false, forKey: Const.UserDefaultsKey.isAppleLogin)
                }
            }
        }
    }
    
    private func presentToMainTabBar() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar) as? MainTBC else { return }
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        
        present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - Network

extension LoginVC {
    
    // TODO: - Network. 회원가입 서버통신
    
    private func signupWithAPI(userID: String) {
        
        // TODO: - 엑세스 토큰 userdefaults 등록하고 화면전환
        
        presentToMainTabBar()
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
            signupWithAPI(userID: userIdentifier)
            
            UserDefaults.standard.set(true, forKey: Const.UserDefaultsKey.isAppleLogin)
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
