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
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                imageView
                
                Text(viewModel.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1...3)
                
                let count = viewModel.count
                let isNavigationLink = viewModel.isNavigationLink
                
                if count > 0 || isNavigationLink {
                    Spacer()
                }
                
                if count > 0 {
                    NewArticlesCountView(count: count)
                        .padding(.trailing, 8)
                }
                
                if isNavigationLink {
                    Image(systemName: Constants.SymbolNames.chevronRight)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 8)
                        .opacity(0.5)
                }
            }
            
            Text(viewModel.description)
                .font(.subheadline)
                .opacity(0.8)
            
        }
        .foregroundStyle(Color.primary)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.indigo)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let image = viewModel.image {
            switch image {
            case .remote(let url):
                AsyncImage(url: url) { image in
                    switch image {
                    case .success(let img):
                        img
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.trailing, 8)
                    case .empty:
                        Color.secondary
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.trailing, 8)
                    default:
                        EmptyView()
                    }
                }
            case .symbol(let systemName):
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 8)
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
