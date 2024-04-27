//
//  RssFeedRepository.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation
import Combine

protocol ChannelRepositoryProtocol {
    func loadFromLocalStorage()
    func subscribeToFeed(with feedUrl: URL) async throws
    func remove(_ channel: Channel)
    func update(_ channel: Channel)
    var channelPublisher: AnyPublisher<[Channel], Never> { get }
}

final class ChannelRepository: ChannelRepositoryProtocol {
    private let remoteDatasource: RemoteChannelDatasourceProtocol
    private let localDatasource: LocalChannelDatasourceProtocol
    private let channelSubject: CurrentValueSubject<[Channel]?, Never> = CurrentValueSubject(nil)
    
    init(
        remoteDatasource: RemoteChannelDatasourceProtocol = RemoteChannelDatasource(),
        localDatasource: LocalChannelDatasourceProtocol = LocalChannelDatasource()
    ) {
        self.remoteDatasource = remoteDatasource
        self.localDatasource = localDatasource
    }
    
    static let shared = ChannelRepository()
    
    func loadFromLocalStorage() {
        let result = localDatasource.get()
        
        channelSubject.send(result)
    }
    
    func subscribeToFeed(with feedUrl: URL) async throws {
        let channel = try await remoteDatasource.fetch(from: feedUrl)
        
        localDatasource.store(channel)
        let result = localDatasource.get()
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
    
    var channelPublisher: AnyPublisher<[Channel], Never> {
        channelSubject
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
}
