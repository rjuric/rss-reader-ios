//
//  UnsubscribeFromChannelUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol UnsubscribeFromChannelUseCaseProtocol {
    func execute(_ channel: Channel)
}

extension UnsubscribeFromChannelUseCaseProtocol {
    func callAsFunction(_ channel: Channel) {
        execute(channel)
    }
}

struct UnsubscribeFromChannelUseCase: UnsubscribeFromChannelUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute(_ channel: Channel) {
        channelRepository.remove(channel)
    }
}
