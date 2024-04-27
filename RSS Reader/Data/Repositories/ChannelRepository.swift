//
//  RssFeedRepository.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation
import Combine

protocol ChannelRepositoryProtocol: AnyObject {
    func loadFromLocalStorage()
    func subscribeToFeed(with feedUrl: URL) async throws
    func remove(_ channel: Channel)
    func update(_ channel: Channel)
    func refresh(_ channel: Channel) async
    var channelPublisher: AnyPublisher<[Channel], Never> { get }
}

final class ChannelRepository: ChannelRepositoryProtocol {
    private let remoteDatasource: RemoteChannelDatasourceProtocol
    private let localDatasource: LocalChannelDatasourceProtocol
    private let channelSubject: CurrentValueSubject<[Channel]?, Never> = CurrentValueSubject(nil)
    private var refreshManager: RefreshManagerProtocol
    
    init(
        remoteDatasource: RemoteChannelDatasourceProtocol = RemoteChannelDatasource(),
        localDatasource: LocalChannelDatasourceProtocol = LocalChannelDatasource(),
        refreshManager: RefreshManagerProtocol = RefreshManager()
    ) {
        self.remoteDatasource = remoteDatasource
        self.localDatasource = localDatasource
        self.refreshManager = refreshManager
        
        self.refreshManager.channelRepository = self
    }
    
    static let shared = ChannelRepository()
    
    func loadFromLocalStorage() {
        let channels = localDatasource.get()
        
        refreshManager.registerAll(channels)
        
        channelSubject.send(channels)
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
    }
    
    func update(_ channel: Channel) {
        localDatasource.update(channel)
        let result = localDatasource.get()
        channelSubject.send(result)
    }
    
    func refresh(_ channel: Channel) async {
        guard let updatedChannel = try? await remoteDatasource.fetch(from: channel.url) else {
            return
        }
        
        update(updatedChannel)
    }
    
    var channelPublisher: AnyPublisher<[Channel], Never> {
        channelSubject
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
}
