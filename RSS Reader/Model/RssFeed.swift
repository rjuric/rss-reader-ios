//
//  RssFeed.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

struct RssFeed {
    let title: String
    var image: URL?
    let description: String
}

extension RssFeed: Identifiable {
    var id: String {
        title
    }
}
