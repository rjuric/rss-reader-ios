//
//  ScheduleBackgroundRefreshUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 29.04.2024..
//

import Foundation
import BackgroundTasks

protocol ScheduleBackgroundRefreshUseCaseProtocol {
    func execute() 
}

extension ScheduleBackgroundRefreshUseCaseProtocol {
    func callAsFunction() {
        execute()
    }
}

struct ScheduleBackgroundRefreshUseCase: ScheduleBackgroundRefreshUseCaseProtocol {
    func execute() {
        let request = BGAppRefreshTaskRequest(identifier: Constants.Identifiers.refresh)
        request.earliestBeginDate = .now.addingTimeInterval(Double(Constants.TimeIntervals.minute15))
        try? BGTaskScheduler.shared.submit(request)
    }
}

#if DEBUG
struct PreviewScheduleBackgroundRefreshUseCase: ScheduleBackgroundRefreshUseCaseProtocol {
    func execute() {
        print("Scheduled background refresh task")
    }
}
#endif
