//
//  ChannelToChannelModelMapper.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation
import RealmSwift

protocol ChannelToChannelModelMapperProtocol {
    func map(from channel: Channel) -> ChannelModel
}

struct ChannelToChannelModelMapper: ChannelToChannelModelMapperProtocol {
    var articleToArticleModelMapper: ArticleToArticleModelMapperProtocol = ArticleToArticleModelMapper()
    
    func map(from channel: Channel) -> ChannelModel {
        ChannelModel(
            value: [
                "title": channel.title,
                "subtitle": channel.description,
                "isFavorite": channel.isFavorite,
                "image": channel.image?.absoluteString as Any,
                "articles": channel.articles.map(articleToArticleModelMapper.map)
            ]
        )
    }
}
