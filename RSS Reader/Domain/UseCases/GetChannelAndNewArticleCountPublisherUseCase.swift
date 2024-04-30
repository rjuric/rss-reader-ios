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
    var mergeChannelsWithNewArticleCounts: MergeChannelsAndNewArticlesCountUseCaseProtocol = MergeChannelsAndNewArticlesCountUseCase()
    
    func execute() -> AnyPublisher<[ArticleCountChannel], Never> {
        let channelPublisher = getChannelsPublisher()
        let newArticleCountPublisher = getNewArticleCountPublisher()
        
        return channelPublisher
            .combineLatest(newArticleCountPublisher)
            .eraseToAnyPublisher()
            .map(mergeChannelsWithNewArticleCounts.execute)
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
