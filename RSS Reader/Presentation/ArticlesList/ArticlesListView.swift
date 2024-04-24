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
                    FeedRowView(viewModel: FeedRowViewModel(from: article))
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(viewModel.publication.uppercased())
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
                        description: "Pogledajte što je napravio",
                        url: URL(string: "https://www.vecernji.hr/vijesti/raskol-u-mostu-marija-selak-raspudic-prva-ima-konferenciju-za-medije-onda-bozo-petrov-1763955")!
                    ),
                    Article(
                        title: "[VIDEO] Raspudići napuštaju Most",
                        image: nil,
                        description: "Tragedija hrvatskog naroda",
                        url: URL(string: "https://www.vecernji.hr/sport/u-hajduk-se-vraca-bivsi-trener-talijani-se-raspisali-o-kandidatu-za-klupu-na-poljudu-1764180")!
                    ),
                    Article(
                        title: "Penava: Što rade našoj djeci?",
                        image: URL(string: "https://picsum.photos/200")!,
                        description: "Djeca uče arapske brojeve u školi",
                        url: URL(string: "https://www.vecernji.hr/showbiz/baby-lasagni-ukrali-identitet-ozbiljno-se-obratio-publici-nemojte-dati-novac-to-nisam-ja-1761523")!
                    ),
                ],
                publication: "Večernji"
            )
        )
    }
}
