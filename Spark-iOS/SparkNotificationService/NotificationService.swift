//
//  NotificationService.swift
//  SparkNotificationService
//
//  Created by kimhyungyu on 2022/03/17.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent,
           let fcmOptionsUserInfo = bestAttemptContent.userInfo["fcm_options"] as? [String: Any] {
            guard let imageURLString = fcmOptionsUserInfo["image"] as? String else {
                contentHandler(bestAttemptContent)
                return
            }
            let imageURL = URL(string: imageURLString)!
            
            // TODO: - 이미지 다운로드
//            guard let imageData = try? Data(contentsOf: imageURL) else {
//                contentHandler(bestAttemptContent)
//                return
//            }
            
            // TODO: - UNNotificationAttachment 생성
//            do {
//                let attachment = try UNNotificationAttachment(identifier: "certificationImage", url: "URL", options: nil)
//                bestAttemptContent.attachments = [attachment]
//            } catch {
//                print("error")
//            }
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
