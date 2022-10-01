//
//  URL.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/15.
//

import Foundation

extension Const {
    struct URL {
        static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
        /// 약관 및 정책
        static let tosURL = "https://jealous-supernova-274.notion.site/433c8d2f5fdd4826a836293e522f1d51"
        /// 오픈소스 라이브러리
        static let openSourceLibraryURL = "https://jealous-supernova-274.notion.site/iOS-92d5ebc5adb44595833f45604567bf18"
        /// 이용약관
        static let termsOfUse = "https://jealous-supernova-274.notion.site/81b28d377e674f9da54566d7da1da6a6"
        /// 개인정보 처리방침
        static let privatePolicy = "https://jealous-supernova-274.notion.site/eb4f206624434b4289aff279052e990d"
        static let itunesURL = "https://itunes.apple.com/lookup?bundleId="
        static let appStoreURLScheme = "itms-apps://itunes.apple.com/app/1605811861"
    }
}
