//
//  RefreshAllChannelsUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 29.04.2024..
//

import Foundation

protocol RefreshAllChannelsUseCaseProtocol {
    func execute() async throws
}

extension RefreshAllChannelsUseCaseProtocol {
    func callAsFunction() async throws {
        try await execute()
    }
}

struct RefreshAllChannelsUseCase: RefreshAllChannelsUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute() async throws {
        try await channelRepository.refreshAllChannels()
    }
}

#if DEBUG
struct PreviewRefreshAllChannelsUseCase: RefreshAllChannelsUseCaseProtocol {
    var isErroring: Bool
    
    func execute() async throws {
        guard isErroring else { return }
        
        throw RssReaderError.wrongFeedFormat
    }
}
#endif
