//
//  RequestNotificationAuthorizationUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 29.04.2024..
//

import Foundation
import UserNotifications

protocol RequestNotificationAuthorizationUseCaseProtocol {
    func execute() async
}

extension RequestNotificationAuthorizationUseCaseProtocol {
    func callAsFunction() async {
        await execute()
    }
}

struct RequestNotificationAuthorizationUseCase: RequestNotificationAuthorizationUseCaseProtocol {
    func execute() async {
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
    }
}

#if DEBUG
struct PreviewRequestNotificationAuthorizationUseCase: RequestNotificationAuthorizationUseCaseProtocol {
    func execute() async { }
}
#endif
