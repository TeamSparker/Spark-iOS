//
//  SplashVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/13.
//

import UIKit

import Lottie
import SnapKit

class SplashVC: UIViewController {

    // MARK: - Properties
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
 
    lazy var lottieLogoView: AnimationView =  {
        let animationView = AnimationView(name: Const.Lottie.Name.splashLogo)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        animationView.stop()
        animationView.isHidden = true
        
        return animationView
    }()
    lazy var lottieBgView: AnimationView = {
        let animationView = AnimationView(name: Const.Lottie.Name.splashBackground)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        animationView.stop()
        animationView.isHidden = true
       
        return animationView
    }()
    
    let splashLabel = UILabel()
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if self.appDelegate?.isLogin == true {
                self.doorBellWithAPI()
            } else {
                if UserDefaults.standard.object(forKey: Const.UserDefaultsKey.isOnboarding) != nil {
                    self.presentToLoginVC()
                } else {
                    self.presentToOnboardingVC()
                }
            }
        }
    }
}
    
// MARK: - Functions

extension SplashVC {
    private func setUI() {
        lottieBgView.isHidden = false
        lottieBgView.play()
        lottieLogoView.isHidden = false
        lottieLogoView.play()
        
        splashLabel.text = "습관에 불을 지펴봐!"
        splashLabel.font = .krMediumFont(ofSize: 18)
        splashLabel.textColor = .sparkWhite
    }
    
    private func setLayout() {
        view.addSubviews([lottieBgView, lottieLogoView, splashLabel])
        
        lottieBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        lottieLogoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(232)
        }
        splashLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(45)
        }
    }
    
    private func presentToMainTBC() {
        guard let mainVC = UIStoryboard(name: Const.Storyboard.Name.mainTabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.mainTabBar) as? MainTBC else { return }
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        
        self.present(mainVC, animated: true, completion: nil)
    }
    
    private func presentToLoginVC() {
        guard let loginVC = UIStoryboard(name: Const.Storyboard.Name.login, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.login) as? LoginVC else { return }
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        self.present(loginVC, animated: true, completion: nil)
    }

    private func presentToOnboardingVC() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.onboarding, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.onboarding) as? OnboardingVC else { return }
        nextVC.modalPresentationStyle = .fullScreen
        
        self.present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - Network

extension SplashVC {
    /// 자동 로그인시 액세스 토큰 갱신목적의 서버통신.
    private func doorBellWithAPI() {
        let isAppleLogin = UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.isAppleLogin)
        let userID = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? ""
        
        let socialID = isAppleLogin ? "Apple@\(userID)" : "Kakao@\(userID)"
        let fcmToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.fcmToken) ?? ""
        
        AuthAPI(viewController: self).login(socialID: socialID, fcmToken: fcmToken) { response in
            switch response {
            case .success(let data):
                if let data = data as? Login {
                    if data.isNew {
                        // 회원가입을 하지 않은 사용자입니다.
                        self.presentToLoginVC()
                    } else {
                        // 회원 정보를 불러왔습니다.
                        UserDefaults.standard.set(data.accesstoken, forKey: Const.UserDefaultsKey.accessToken)
                        
                        self.presentToMainTBC()
                    }
                }
            case .requestErr(let message):
                print("doorBellWithAPI - requestErr: \(message)")
            case .pathErr:
                print("doorBellWithAPI - pathErr")
            case .serverErr:
                print("doorBellWithAPI - serverErr")
            case .networkFail:
                print("doorBellWithAPI - networkFail")
            }
        }
    }
}
