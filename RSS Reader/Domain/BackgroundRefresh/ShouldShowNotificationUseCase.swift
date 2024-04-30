//
//  ShouldShowNotificationUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 29.04.2024..
//

import Foundation

protocol ShouldShowNotificationUseCaseProtocol {
    func execute() async throws -> Bool
}

extension ShouldShowNotificationUseCaseProtocol {
    func callAsFunction() async throws -> Bool {
        try await execute()
    }
}

struct ShouldShowNotificationUseCase: ShouldShowNotificationUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute() async throws -> Bool {
        let differencesBefore = channelRepository.articleDifference
        try await channelRepository.refreshAllChannels()
        let differencesAfter = channelRepository.articleDifference
        
        let differentKey = differencesAfter.keys.first { key in
            differencesBefore[key] != differencesAfter[key]
        }
        
        return !differentKey.isNil
    }
}
