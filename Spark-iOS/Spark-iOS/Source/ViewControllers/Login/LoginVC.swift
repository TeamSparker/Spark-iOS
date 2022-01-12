//
//  LoginVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/12.
//

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
        
        // TODO: - 로그인 라벨 폰트 적용
//        loginLabel.font = .
        
        kakaoLoginButton.setImage(UIImage(named: "btnKakaoLogin"), for: .normal)
        appleLoginButton.setImage(UIImage(named: "btnAppleLogin"), for: .normal)
    }
    
    
    private func signupWithKakao() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            loginWithKakaoApp()
        }
        else {
            loginWithWeb()
        }
    }
    
    private func loginWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoApp() success.")
                
                self.getUserID()
            }
        }
    }
    
    private func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
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
                    self.signupWithAPI(userID: Int(userID))
                    
                    // TODO: - 키체인
                    
                }
            }
        }
    }
    
    private func presentToMainTabBar() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar) as? MainTBC else { return }
        nextVC.modalPresentationStyle = .fullScreen
        
        present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - Network

extension LoginVC {
    private func signupWithAPI(userID: Int) {
        // TODO: - 회원가입 성공 시 화면전환
        presentToMainTabBar()
    }
}
