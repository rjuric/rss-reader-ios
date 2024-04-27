//
//  InitializeWithStoredChannelsUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation

protocol InitializeWithStoredChannelsUseCaseProtocol {
    func execute() async throws
}

extension InitializeWithStoredChannelsUseCaseProtocol {
    func callAsFunction() async throws {
        try await execute()
    }
}

struct InitializeWithStoredChannelsUseCase: InitializeWithStoredChannelsUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute() async throws {
        try await channelRepository.loadFromLocalStorage()
    }
}
