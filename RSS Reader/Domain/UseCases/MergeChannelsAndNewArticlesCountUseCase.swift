//
//  MergeChannelsAndNewArticlesCountUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 29.04.2024..
//

import Foundation

protocol MergeChannelsAndNewArticlesCountUseCaseProtocol {
    func execute(_ channels: [Channel], with newArticleCounts: [String: Int]) -> [ArticleCountChannel]
}

extension MergeChannelsAndNewArticlesCountUseCaseProtocol {
    func callAsFunction(_ channels: [Channel], with newArticleCounts: [String: Int]) -> [ArticleCountChannel] {
        execute(channels, with: newArticleCounts)
    }
}

struct MergeChannelsAndNewArticlesCountUseCase: MergeChannelsAndNewArticlesCountUseCaseProtocol {
    func execute(_ channels: [Channel], with newArticleCounts: [String : Int]) -> [ArticleCountChannel] {
        channels.map({ ArticleCountChannel(channel: $0, articleCount: newArticleCounts[$0.id] ?? 0) })
    }
}
