//
//  RemoteChannelDatasource.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation

protocol RemoteChannelDatasourceProtocol {
    func fetch(from channelUrl: URL) async throws -> Channel
}

struct RemoteChannelDatasource: RemoteChannelDatasourceProtocol {
    var feedFetcher: RssFeedServiceProtocol = RssFeedService()
    var channelMapper: FeedToChannelMapperProtocol = FeedToChannelMapper()
    
    func fetch(from channelUrl: URL) async throws -> Channel {
        let feed = try await feedFetcher.fetch(from: channelUrl)
        let channel = try channelMapper.map(feed: feed, with: channelUrl)
        
        return channel
    }
}
