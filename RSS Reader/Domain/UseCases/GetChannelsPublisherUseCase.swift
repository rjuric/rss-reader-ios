//
//  GetChannelsPublisherUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 25.04.2024..
//

import Foundation
import Combine

protocol GetChannelsPublisherUseCaseProtocol {
    func execute() -> AnyPublisher<[Channel], Never>
}

extension GetChannelsPublisherUseCaseProtocol {
    func callAsFunction() -> AnyPublisher<[Channel], Never> {
        execute()
    }
}

struct GetChannelsPublisherUseCase: GetChannelsPublisherUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute() -> AnyPublisher<[Channel], Never> {
        channelRepository.channelPublisher
    }
}
