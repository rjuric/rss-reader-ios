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
        let result = try await remoteDatasource.fetch(from: feedUrl)
        
        localDatasource.store(result)
        
        var currentValue = channelSubject.value ?? []
        currentValue.append(result)
        
        channelSubject.send(currentValue)
    }
    
    var channelPublisher: AnyPublisher<[Channel], Never> {
        channelSubject
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
}
