//
//  SubscribeToChannelUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation

protocol SubscribeToChannelUseCaseProtocol {
    func execute(with channelUrl: URL) async throws
}

extension SubscribeToChannelUseCaseProtocol {
    func callAsFunction(with channelUrl: URL) async throws {
        try await execute(with: channelUrl)
    }
}

struct SubscribeToChannelUseCase: SubscribeToChannelUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute(with channelUrl: URL) async throws {
        try await channelRepository.subscribeToFeed(with: channelUrl)
    }
}

#if DEBUG
struct PreviewSubscribeToChannelUseCase: SubscribeToChannelUseCaseProtocol {
    let isErroring: Bool
    
    func execute(with channelUrl: URL) async throws {
        guard isErroring else { return }
        
        throw RssReaderError.wrongFeedFormat
    }
}
#endif
