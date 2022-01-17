//
//  Const.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/04.
//

import Foundation

struct Const {
    /*
     Const.Storyboard.main 과 같이 사용.
     Const.ViewController.Identifier.main 과 같이 사용.
     Const.Xib.NibName.mainCVC 과 같이 사용.
     Notification.Name 을 extension 했기 때문에 .sendData 와 같이 사용가능.
     */
    
    static let accessToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) ?? ""
}
