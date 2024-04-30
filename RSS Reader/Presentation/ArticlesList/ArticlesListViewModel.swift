//
//  ArticlesListViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

struct ArticlesListViewModel {
    var clearArticleCount: ClearNewArticleCountProtocol = ClearNewArticleCountUseCase()
    
    let articles: [Article]
    let publication: String
    let id: String
    
    func onAppear() {
        clearArticleCount(for: id)
    }
    
    var navigationTitle: String {
        publication.uppercased()
    }
}

extension ArticlesListViewModel: Equatable {
    static func == (lhs: ArticlesListViewModel, rhs: ArticlesListViewModel) -> Bool {
        lhs.publication == rhs.publication && lhs.articles == rhs.articles
    }
}

extension ArticlesListViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(publication)
        hasher.combine(articles.count)
    }
}
