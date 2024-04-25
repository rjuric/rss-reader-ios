//
//  SubscribeToChannelUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation

protocol SubscribeToChannelUseCaseProtocol {
    func execute(with feedUrl: URL) async throws
}

extension SubscribeToChannelUseCaseProtocol {
    func callAsFunction(with feedUrl: URL) async throws {
        try await execute(with: feedUrl)
    }
}

struct SubscribeToChannelUseCase: SubscribeToChannelUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository()
    
    func execute(with feedUrl: URL) async throws {
        try await channelRepository.subscribeToFeed(with: feedUrl)
    }
}
