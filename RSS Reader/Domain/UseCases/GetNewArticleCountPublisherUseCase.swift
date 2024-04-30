//
//  GetNewArticleCountPublisherUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 29.04.2024..
//

import Foundation
import Combine

protocol GetNewArticleCountPublisherUseCaseProtocol {
    func execute() -> AnyPublisher<[String: Int], Never>
}

extension GetNewArticleCountPublisherUseCaseProtocol {
    func callAsFunction() -> AnyPublisher<[String: Int], Never> {
        execute()
    }
}

struct GetNewArticleCountPublisherUseCase: GetNewArticleCountPublisherUseCaseProtocol {
    var channelRepository: ChannelRepositoryProtocol = ChannelRepository.shared
    
    func execute() -> AnyPublisher<[String : Int], Never> {
        channelRepository.articleCountPublisher
    }
}

#if DEBUG
struct PreviewGetNewArticleCountPublisherUseCase: GetNewArticleCountPublisherUseCaseProtocol {
    var publisher: AnyPublisher<[String: Int], Never> = CurrentValueSubject<[String: Int], Never>([:]).eraseToAnyPublisher()
    
    func execute() -> AnyPublisher<[String : Int], Never> {
        publisher
    }
}
#endif
