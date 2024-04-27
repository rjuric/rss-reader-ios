//
//  InitializeWithStoredChannelsUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation

protocol InitializeWithStoredChannelsUseCaseProtocol {
    func execute()
}

extension InitializeWithStoredChannelsUseCaseProtocol {
    func callAsFunction() {
        execute()
    }
}

struct InitializeWithStoredChannelsUseCase: InitializeWithStoredChannelsUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute() {
        channelRepository.loadFromLocalStorage()
    }
}
