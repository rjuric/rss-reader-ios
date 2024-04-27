//
//  RowViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

struct RowViewModel {
    let title: String
    var image: FeedRowImage?
    let description: String
    var count = 0
    
    enum FeedRowImage {
        case remote(URL)
        case symbol(String)
    }
}

extension RowViewModel {
    init(from rssFeed: Channel, with newArticleCount: Int) {
        title = rssFeed.title
        description = rssFeed.description
        count = newArticleCount
        
        guard let imageUrl = rssFeed.image else { return }
        
        image = .remote(imageUrl)
    }
}

extension RowViewModel {
    init(from article: Article) {
        title = article.title
        description = article.description
        
        guard let imageUrl = article.image else { return }
        
        image = .remote(imageUrl)
    }
}
