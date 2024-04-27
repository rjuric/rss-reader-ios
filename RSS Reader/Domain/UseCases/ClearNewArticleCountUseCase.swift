//
//  ClearNewArticleCountUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol ClearNewArticleCountProtocol {
    func execute(for channelId: String)
}

extension ClearNewArticleCountProtocol {
    func callAsFunction(for channelId: String) {
        execute(for: channelId)
    }
}

struct ClearNewArticleCountUseCase: ClearNewArticleCountProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute(for channelId: String) {
        channelRepository.clearNewArticlesCount(for: channelId)
    }
}
