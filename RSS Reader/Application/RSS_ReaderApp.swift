//
//  RSS_ReaderApp.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI
import BackgroundTasks

@main
struct RSS_ReaderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var phase
    
    var scheduleAppRefresh: ScheduleBackgroundRefreshUseCaseProtocol = ScheduleBackgroundRefreshUseCase()
    var shouldShowNotification: ShouldShowNotificationUseCaseProtocol = ShouldShowNotificationUseCase()
    var showNotification: ShowNotificationUseCaseProtocol = ShowNotificationUseCase()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .background: 
                scheduleAppRefresh()
            default: break
            }
        }
        .backgroundTask(.appRefresh(Constants.Identifiers.refresh)) {
            await scheduleAppRefresh()
            
            let isShowingNotification = try? await shouldShowNotification()
            
            guard isShowingNotification == true else { return }
            
            await showNotification()
        }
    }
}
