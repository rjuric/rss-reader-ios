//
//  GetChannelAndNewArticleCountPublisherUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 29.04.2024..
//

import Foundation
import Combine

protocol GetChannelAndNewArticleCountPublisherUseCaseProtocol {
    func execute() -> AnyPublisher<[ArticleCountChannel], Never>
}

extension GetChannelAndNewArticleCountPublisherUseCaseProtocol {
    func callAsFunction() -> AnyPublisher<[ArticleCountChannel], Never> {
        execute()
    }
}

struct GetChannelAndNewArticleCountPublisherUseCase: GetChannelAndNewArticleCountPublisherUseCaseProtocol {
    var getChannelsPublisher: GetChannelsPublisherUseCaseProtocol = GetChannelsPublisherUseCase()
    var getNewArticleCountPublisher: GetNewArticleCountPublisherUseCaseProtocol = GetNewArticleCountPublisherUseCase()
    
    func execute() -> AnyPublisher<[ArticleCountChannel], Never> {
        let channelPublisher = getChannelsPublisher()
        let newArticleCountPublisher = getNewArticleCountPublisher()
        
        return channelPublisher
            .combineLatest(newArticleCountPublisher)
            .eraseToAnyPublisher()
            .map { channels, articleCounts in
                channels.map({ ArticleCountChannel(channel: $0, articleCount: articleCounts[$0.id] ?? 0) })
            }
            .eraseToAnyPublisher()
    }
}

#if DEBUG
struct PreviewGetChannelAndNewArticleCountPublisherUseCase: GetChannelAndNewArticleCountPublisherUseCaseProtocol {
    var returnValue: AnyPublisher<[ArticleCountChannel], Never> = CurrentValueSubject<[ArticleCountChannel], Never>([]).eraseToAnyPublisher()
    
    func execute() -> AnyPublisher<[ArticleCountChannel], Never> {
        returnValue
    }
}
#endif
