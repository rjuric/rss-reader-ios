//
//  NewFeedViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import Foundation

@MainActor
final class NewFeedViewModel: ObservableObject {
    let isFirstFeed: Bool
    
    @Published var isLoading = false
    @Published var inputText = ""
    
    init(isFirstFeed: Bool) {
        self.isFirstFeed = isFirstFeed
    }
    
    func onSubmit() async {
        isLoading = true
        defer { isLoading = false }
        
        try? await Task.sleep(for: .seconds(2))
        
        // TODO: Add persistance and responsiveness
    }
}
