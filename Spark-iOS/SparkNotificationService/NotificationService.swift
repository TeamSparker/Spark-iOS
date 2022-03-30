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
            
            guard let periodIndex = imageURLString.lastIndex(of: ".") else { return }
            let imageURL = imageURLString[imageURLString.startIndex..<periodIndex]
            // .png or .jpeg
            let imageType = imageURLString[periodIndex..<imageURLString.endIndex]
            
            let resizingURL = String(imageURL + "_720x720" + imageType)
            let url = URL(string: resizingURL)!
            
            // download image.
            guard let imageData = try? Data(contentsOf: url) else {
                contentHandler(bestAttemptContent)
                return
            }

            // set UNNotificationAttachment.
            guard let attachment = UNNotificationAttachment.saveImageToDisk(identifier: "certificationImage.jpg", data: imageData, options: nil) else {
                contentHandler(bestAttemptContent)
                return
            }
            bestAttemptContent.attachments = [attachment]
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

// MARK: - UNNotificationAttachment

extension UNNotificationAttachment {
    static func saveImageToDisk(identifier: String, data: Data, options: [AnyHashable: Any]? = nil) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL.appendingPathComponent(identifier)
            try data.write(to: fileURL, options: [])
            let attachment = try UNNotificationAttachment(identifier: identifier, url: fileURL, options: options)
            
            return attachment
        } catch {
            print("saveImageToDisk error - \(error)")
        }
        return nil
    }
}
