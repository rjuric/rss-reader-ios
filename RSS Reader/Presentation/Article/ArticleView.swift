//
//  ArticleView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct ArticleView: View {
    let viewModel: ArticleViewModel
    
    @Environment(\.openURL) private var openUrl
    
    var body: some View {
        WebView(url: viewModel.url)
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { openUrl(viewModel.url) }) {
                        Image(systemName: Constants.SymbolNames.safari)
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        ArticleView(
            viewModel: ArticleViewModel(
                title: "Tournament Brackets in SwiftUI",
                url: URL(string: "https://medium.com/@rjuric/tournament-brackets-in-swiftui-ccdd2266fe62")!
            )
        )
    }
}
