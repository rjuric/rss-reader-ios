//
//  GetNewArticlesCountUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol GetNewArticlesCountUseCaseProtocol {
    func execute(for channelId: String) -> Int
}

extension GetNewArticlesCountUseCaseProtocol {
    func callAsFunction(for channelId: String) -> Int {
        execute(for: channelId)
    }
}

struct GetNewArticlesCount: GetNewArticlesCountUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute(for channelId: String) -> Int {
        channelRepository.getNewArticlesCount(for: channelId)
    }
}
