//
//  RemoteChannelDatasource.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation

protocol RemoteChannelDatasourceProtocol {
    func fetch(from feedUrl: URL) async throws -> Channel
}

struct RemoteChannelDatasource: RemoteChannelDatasourceProtocol {
    var feedFetcher: RssFeedFetcherProtocol = RssFeedFetcher()
    var channelMapper: FeedToChannelMapperProtocol = FeedToChannelMapper()
    
    func fetch(from feedUrl: URL) async throws -> Channel {
        let feed = try await feedFetcher.fetch(from: feedUrl)
        let channel = try channelMapper.map(feed: feed)
        
        return channel
    }
}
