//
//  Article.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

struct Article {
    let title: String
    let image: URL?
    let description: String
    let url: URL
}

extension Article: Identifiable {
    var id: String {
        title
    }
}

#if DEBUG
extension Article {
    init(title: String, image: URL? = nil, description: String) {
        self.title = title
        self.image = image
        self.description = description
        self.url = URL(string: "https://en.wikipedia.org/wiki/Special:Random")!
    }
}
#endif

extension Article: Equatable {}

extension Article: Codable {}
