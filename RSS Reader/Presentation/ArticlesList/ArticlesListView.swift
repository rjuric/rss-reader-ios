//
//  ArticleView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct ArticlesListView: View {
    let viewModel: ArticlesListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.articles) { article in
                NavigationLink(value: NavigationDestination.article(ArticleViewModel(from: article))) {
                    RowView(viewModel: RowViewModel(from: article))
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(viewModel.publication.uppercased())
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    NavigationStack {
        ArticlesListView(
            viewModel: ArticlesListViewModel(
                articles: [
                    Article(
                        title: "[ŠOK] Prebio dvojicu ispred Velveta",
                        image: URL(string: "https://picsum.photos/200")!,
                        description: "Pogledajte što je napravio"
                    ),
                    Article(
                        title: "[VIDEO] Raspudići napuštaju Most",
                        image: nil,
                        description: "Tragedija hrvatskog naroda"
                    ),
                    Article(
                        title: "Penava: Što rade našoj djeci?",
                        image: URL(string: "https://picsum.photos/200")!,
                        description: "Djeca uče arapske brojeve u školi"
                    ),
                ],
                publication: "Večernji",
                id: "Večernji"
            )
        )
    }
}
