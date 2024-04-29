//
//  ShowNotificationUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 29.04.2024..
//

import Foundation
import UserNotifications

protocol ShowNotificationUseCaseProtocol {
    func execute() async
}

extension ShowNotificationUseCaseProtocol {
    func callAsFunction() async {
        await execute()
    }
}

struct ShowNotificationUseCase: ShowNotificationUseCaseProtocol {
    func execute() async {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Notifications.Title")
        content.body = String(localized: "Notifications.Body")
        
        let request = UNNotificationRequest(identifier: Constants.Identifiers.notification, content: content, trigger: nil)
        let notificationCenter = UNUserNotificationCenter.current()
        try? await notificationCenter.add(request)
    }
}
