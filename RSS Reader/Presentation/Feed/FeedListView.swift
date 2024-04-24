//
//  FeedListView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct FeedListView: View {
    let feeds: [RssFeed]
    
    var body: some View {
        List {
            Text("Your RSS Feeds")
                .font(.largeTitle)
            
            ForEach(feeds) { rssFeed in
                FeedRowView(feed: rssFeed)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    FeedListView(
        feeds: [
            RssFeed(
                title: "Slobodna Dalmacija",
                image: URL(string: "https://picsum.photos/200"),
                description: "Svježe iz Dalmacije"
            ),
            RssFeed(
                title: "Jutarnji List",
                description: "RSS Feed Jutarnjeg"
            ),
            RssFeed(
                title: "Vecernji",
                description: "RSS Feed Vecernjeg Lista s najnovijim vijestima"
            )
        ]
    )
}
