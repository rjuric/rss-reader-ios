//
//  FeedRowViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

struct FeedRowViewModel {
    let title: String
    var image: FeedRowImage?
    let description: String
    
    enum FeedRowImage {
        case remote(URL)
        case local(String)
    }
}

extension FeedRowViewModel {
    init(from rssFeed: RssFeed) {
        title = rssFeed.title
        description = rssFeed.description
        
        guard let imageUrl = rssFeed.image else { return }
        
        image = .remote(imageUrl)
    }
}

extension FeedRowViewModel {
    init(from article: Article) {
        title = article.title
        description = article.description
        
        guard let imageUrl = article.image else { return }
        
        image = .remote(imageUrl)
    }
}
