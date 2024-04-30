//
//  Channel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

struct Channel {
    let title: String
    var image: URL?
    let description: String
    var isFavorite: Bool = false
    var articles: [Article] = []
    var url: URL
}

extension Channel: Identifiable {
    var id: String {
        url.absoluteString
    }
}

extension Channel: Equatable {}

extension Channel: Codable {}
