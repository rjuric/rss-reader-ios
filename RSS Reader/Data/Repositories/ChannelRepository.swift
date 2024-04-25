//
//  RssFeedRepository.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation

protocol ChannelRepositoryProtocol {
    func subscribeToFeed(with feedUrl: URL) async throws
}

struct ChannelRepository: ChannelRepositoryProtocol {
    var remoteDatasource: RemoteChannelDatasourceProtocol = RemoteChannelDatasource()
    
    func subscribeToFeed(with feedUrl: URL) async throws {
        _ = try await remoteDatasource.fetch(from: feedUrl)
        // TODO: Persistence
    }
}
