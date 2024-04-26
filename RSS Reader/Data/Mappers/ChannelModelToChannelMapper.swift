//
//  ChannelModelToChannelMapper.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation

protocol ChannelModelToChannelMapperProtocol {
    func map(from model: ChannelModel) throws -> Channel
}

struct ChannelModelToChannelMapper: ChannelModelToChannelMapperProtocol {
    var articleModelToArticleMapper: ArticleModelToArticleMapperProtocol = ArticleModelToArticleMapper()
    
    func map(from model: ChannelModel) throws -> Channel {
        var imageUrl: URL?
        if let imageUrlString = model.image {
            imageUrl = URL(string: imageUrlString)
        }
        
        let articles = try model.articles.map(articleModelToArticleMapper.map)
        
        return Channel(
            title: model.title,
            image: imageUrl,
            description: model.subtitle,
            isFavorite: model.isFavorite,
            articles: articles
        )
    }
}
