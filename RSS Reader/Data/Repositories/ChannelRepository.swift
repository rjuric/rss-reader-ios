//
//  RssFeedRepository.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation
import Combine

protocol ChannelRepositoryProtocol {
    func subscribeToFeed(with feedUrl: URL) async throws
    var channelPublisher: AnyPublisher<[Channel], Never> { get }
}

final class ChannelRepository: ChannelRepositoryProtocol {
    private let remoteDatasource: RemoteChannelDatasourceProtocol
    private let channelSubject: CurrentValueSubject<[Channel]?, Never> = CurrentValueSubject(nil)
    
    init(remoteDatasource: RemoteChannelDatasourceProtocol = RemoteChannelDatasource()) {
        self.remoteDatasource = remoteDatasource
    }
    
    static let shared = ChannelRepository()
    
    func subscribeToFeed(with feedUrl: URL) async throws {
        let result = try await remoteDatasource.fetch(from: feedUrl)
        
        print(result)
        
        var currentValue = channelSubject.value ?? []
        currentValue.append(result)
        
        channelSubject.send(currentValue)
        // TODO: Persistence
    }
    
    var channelPublisher: AnyPublisher<[Channel], Never> {
        channelSubject
            .compactMap({ $0 })
            .eraseToAnyPublisher()
    }
}
