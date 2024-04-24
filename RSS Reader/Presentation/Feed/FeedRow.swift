//
//  FeedRow.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct FeedRow: View {
    let feed: RssFeed
    
    var body: some View {
        HStack(spacing: 8) {
            if let imageUrl = feed.image {
                AsyncImage(url: imageUrl)
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feed.title)
                    .font(.headline)
                
                Text(feed.description)
                    .font(.subheadline)
            }
            .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

#Preview {
    FeedRow(
        feed: RssFeed(
            title: "Slobodna Dalmacija",
            image: URL(string: "https://picsum.photos/200"),
            description: "Svježe iz Dalmacije"
        )
    )
    .padding()
}

#Preview {
    FeedRow(
        feed: RssFeed(
            title: "Jutarnji List",
            description: "RSS Feed Jutarnjeg"
        )
    )
    .padding()
}
