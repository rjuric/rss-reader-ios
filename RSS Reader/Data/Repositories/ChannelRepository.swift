//
//  RssFeedRepository.swift
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
    func getNewArticlesCount(for channelId: String) -> Int
    func clearNewArticlesCount(for channelId: String)
    var channelPublisher: AnyPublisher<[Channel], Never> { get }
}

final class ChannelRepository: ChannelRepositoryProtocol {
    private let remoteDatasource: RemoteChannelDatasourceProtocol
    private let localDatasource: LocalChannelDatasourceProtocol
    private let channelSubject: CurrentValueSubject<[Channel]?, Never> = CurrentValueSubject(nil)
    private var refreshManager: RefreshManagerProtocol
    
    private let checkDifferentArticlesCount: CheckDifferentArticlesCountUseCaseProtocol
    
    var articleDifference: [String: Int] = [:]
    
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
    
    static let shared = ChannelRepository()
    
    func loadFromLocalStorage() async throws {
        let channels = localDatasource.get()
        refreshManager.registerAll(channels)
        channelSubject.send(channels)
        
        try await refreshChannels(channels)
    }
    
    private func refreshChannels(_ channels: [Channel]) async throws {
        for channel in channels {
            try await refresh(channel)
        }
    }
    
    func subscribeToFeed(with feedUrl: URL) async throws {
        let channel = try await remoteDatasource.fetch(from: feedUrl)
        
        localDatasource.store(channel)
        let result = localDatasource.get()
        
        refreshManager.register(channel)
        
        channelSubject.send(result)
    }
    
    func remove(_ channel: Channel) {
        localDatasource.delete(channel)
        let result = localDatasource.get()
        channelSubject.send(result)
        articleDifference.removeValue(forKey: channel.id)
    }
    
    func update(_ channel: Channel) {
        localDatasource.update(channel)
        let result = localDatasource.get()
        channelSubject.send(result)
    }
    
    func refresh(_ channel: Channel) async throws {
        let updatedChannel = try await remoteDatasource.fetch(from: channel.url)
        update(updatedChannel)
        
        let differenceCount = checkDifferentArticlesCount(from: channel.articles, to: updatedChannel.articles)
        articleDifference[channel.id] = differenceCount
    }
    
    func getNewArticlesCount(for channelId: String) -> Int {
        articleDifference[channelId] ?? 0
    }
    
    func clearNewArticlesCount(for channelId: String) {
        articleDifference.removeValue(forKey: channelId)
    }
    
    var channelPublisher: AnyPublisher<[Channel], Never> {
        channelSubject
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
}
