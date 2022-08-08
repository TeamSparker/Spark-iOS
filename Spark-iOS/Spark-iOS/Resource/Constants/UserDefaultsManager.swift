//
//  UserDefaultsManager.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/05/20.
//

import Foundation

struct UserDefaultsManager {
    static var isAppleLogin: Bool {
        get { return UserDefaults.standard.bool(forKey: "isAppleLogin") }
        set { UserDefaults.standard.set(newValue, forKey: "isAppleLogin") }
    }
    
    static var isOnboarding: String? {
        get { return UserDefaults.standard.string(forKey: "isOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "isOnboarding") }
    }

    static var userID: String? {
        get { return UserDefaults.standard.string(forKey: "userID") }
        set { UserDefaults.standard.set(newValue, forKey: "userID") }
    }
    
    static var accessToken: String? {
        get { return UserDefaults.standard.string(forKey: "accessToken") }
        set { UserDefaults.standard.set(newValue, forKey: "accessToken") }
    }
    
    static var fcmToken: String? {
        get { return UserDefaults.standard.string(forKey: "fcmToken") }
        set { UserDefaults.standard.set(newValue, forKey: "fcmToken") }
    }
    
    static var checkHabitRoomGuide: Bool {
        get { return UserDefaults.standard.bool(forKey: "checkHabitRoomGuide") }
        set { UserDefaults.standard.set(newValue, forKey: "checkHabitRoomGuide") }
    }
    
    static var sceneWillEnterForeground: Date? {
        get { return UserDefaults.standard.object(forKey: "sceneWillEnterForeground") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "sceneWillEnterForeground") }
    }
    
    static var sceneDidEnterBackground: Date? {
        get { return UserDefaults.standard.object(forKey: "sceneDidEnterBackground") as? Date}
        set { UserDefaults.standard.set(newValue, forKey: "sceneDidEnterBackground") }
    }
}
