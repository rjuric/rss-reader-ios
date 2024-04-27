//
//  UpdateChannelUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol UpdateChannelUseCaseProtocol {
    func execute(_ channel: Channel)
}

extension UpdateChannelUseCaseProtocol {
    func callAsFunction(_ channel: Channel) {
        execute(channel)
    }
}

struct UpdateChannelUseCase: UpdateChannelUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute(_ channel: Channel) {
        channelRepository.update(channel)
    }
}
