//
//  ContentView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FeedNavigationWrapper {
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
    }
}

#Preview {
    ContentView()
}
