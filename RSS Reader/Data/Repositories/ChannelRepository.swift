//
//  ChannelRepository.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation
import Combine

protocol ChannelRepositoryProtocol: AnyObject {
    func loadFromLocalStorage() async throws
    func subscribeToFeed(with feedUrl: URL) async throws
    func remove(_ channel: Channel)
    func update(_ channel: Channel)
    func refresh(_ channel: Channel) async throws
    func refreshAllChannels() async throws
    func clearNewArticlesCount(for channelId: String)
    var channelPublisher: AnyPublisher<[Channel], Never> { get }
    var articleCountPublisher: AnyPublisher<[String: Int], Never> { get }
    var articleDifference: [String: Int] { get }
}

final class ChannelRepository: ChannelRepositoryProtocol {
    private let remoteDatasource: RemoteChannelDatasourceProtocol
    private let localDatasource: LocalChannelDatasourceProtocol
    @Published private var channelsCache: [Channel] = []
    private var refreshManager: RefreshManagerProtocol
    
    private let checkDifferentArticlesCount: CheckDifferentArticlesCountUseCaseProtocol
    
    @Published var articleDifference: [String: Int] = [:]
    
    init(
        remoteDatasource: RemoteChannelDatasourceProtocol = RemoteChannelDatasource(),
        localDatasource: LocalChannelDatasourceProtocol = LocalChannelDatasource(),
        refreshManager: RefreshManagerProtocol = RefreshManager(),
        checkDifferentArticlesCount: CheckDifferentArticlesCountUseCaseProtocol = CheckDifferentArticlesCountUseCase()
    ) {
        self.remoteDatasource = remoteDatasource
        self.localDatasource = localDatasource
        self.refreshManager = refreshManager
        
        self.checkDifferentArticlesCount = checkDifferentArticlesCount
        
        self.refreshManager.channelRepository = self
    }
    
    static let shared: ChannelRepositoryProtocol = ChannelRepository()
    
    func loadFromLocalStorage() async throws {
        let channels = localDatasource.get()
        refreshManager.registerAll(channels)
        channelsCache = channels
        
        try await refreshChannels(channels)
    }
    
    private func refreshChannels(_ channels: [Channel]) async throws {
        for channel in channels {
            try await refresh(channel)
        }
    }
    
    func refreshAllChannels() async throws {
        try await refreshChannels(channelsCache)
    }
    
    func subscribeToFeed(with feedUrl: URL) async throws {
        guard !channelsCache.contains(where: { $0.url == feedUrl }) else { return }
        
        let channel = try await remoteDatasource.fetch(from: feedUrl, isFavorite: false)
        
        localDatasource.store(channel)
        refreshManager.register(channel)
        
        channelsCache.insert(channel, at: 0)
    }
    
    func remove(_ channel: Channel) {
        localDatasource.delete(channel)
        channelsCache = channelsCache.filter({ $0.id != channel.id })
        refreshManager.unregister(channel)
        articleDifference.removeValue(forKey: channel.id)
    }
    
    func update(_ channel: Channel) {
        localDatasource.update(channel)
        
        guard let index = channelsCache.firstIndex(where: { $0.id == channel.id }) else {
            return
        }
        
        channelsCache[index] = channel
    }
    
    func refresh(_ channel: Channel) async throws {
        let updatedChannel = try await remoteDatasource.fetch(from: channel.url, isFavorite: channel.isFavorite)
        update(updatedChannel)
        
        let differenceCount = checkDifferentArticlesCount(from: channel.articles, to: updatedChannel.articles)
        articleDifference[channel.id] = differenceCount
    }
    
    func clearNewArticlesCount(for channelId: String) {
        articleDifference.removeValue(forKey: channelId)
    }
    
    var channelPublisher: AnyPublisher<[Channel], Never> {
        $channelsCache
            .eraseToAnyPublisher()
    }
    
    var articleCountPublisher: AnyPublisher<[String: Int], Never> {
        $articleDifference
            .eraseToAnyPublisher()
    }
}


