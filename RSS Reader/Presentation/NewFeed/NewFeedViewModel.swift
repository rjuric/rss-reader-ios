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
    
    let subscribeToChannel: SubscribeToChannelUseCaseProtocol
    
    var isSubmitDisabled: Bool {
        isLoading || inputText.isEmpty
    }
    
    init(isFirstFeed: Bool, subscribeToChannel: SubscribeToChannelUseCaseProtocol = SubscribeToChannelUseCase()) {
        self.isFirstFeed = isFirstFeed
        self.subscribeToChannel = subscribeToChannel
    }
    
    func onSubmit() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: inputText) else {
            return
        }
        
        do {
            try await subscribeToChannel(with: url)
        } catch {
            print(error)
        }
        // TODO: Add persistance and responsiveness
    }
    
}
