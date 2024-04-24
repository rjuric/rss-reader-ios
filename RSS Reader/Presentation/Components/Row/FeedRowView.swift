//
//  FeedRow.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct RowView: View {
    let viewModel: RowViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            imageView
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.headline)
                
                Text(viewModel.description)
                    .font(.subheadline)
                    .opacity(0.8)
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let image = viewModel.image {
            switch image {
            case .remote(let url):
                AsyncImage(url: url)
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .symbol(let systemName):
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                    .frame(width: 60, height: 60)
            }
        }
    }
}

#Preview {
    RowView(
        viewModel: RowViewModel(
            title: "Slobodna Dalmacija",
            image: .remote(URL(string: "https://picsum.photos/200")!),
            description: "Svježe iz Dalmacije"
        )
    )
    .padding()
}

#Preview {
    RowView(
        viewModel: RowViewModel(
            title: "Jutarnji List",
            description: "RSS Feed Jutarnjeg"
        )
    )
    .padding()
}
