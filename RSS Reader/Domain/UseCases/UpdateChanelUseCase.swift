//
//  UpdateChanelUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol UpdateChanelUseCaseProtocol {
    func execute(_ channel: Channel)
}

extension UpdateChanelUseCaseProtocol {
    func callAsFunction(_ channel: Channel) {
        execute(channel)
    }
}

struct UpdateChanelUseCase: UpdateChanelUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute(_ channel: Channel) {
        channelRepository.update(channel)
    }
}
