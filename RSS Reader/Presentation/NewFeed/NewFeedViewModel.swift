//
//  NewFeedViewModel.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

@MainActor
final class NewFeedViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var inputText = ""
    @Published var isError = false
    
    private let subscribeToChannel: SubscribeToChannelUseCaseProtocol
    private let getDidShowOnboarding: GetDidShowOnboardingUseCaseProtocol
    private let getAppFlags: GetAppFlagsUseCaseProtocol
    private let setAppFlags: SetAppFlagsUseCaseProtocol
    
    var isSubmitDisabled: Bool {
        isLoading || inputText.isEmpty || !isValidUrl
    }
    
    private var isValidUrl: Bool {
        guard let url = URL(string: inputText) else { return false }
        
        guard let scheme = url.scheme,
              scheme == "https" || scheme == "http" 
        else {
            return false
        }
        
        return true
    }
    
    init(
        subscribeToChannel: SubscribeToChannelUseCaseProtocol = SubscribeToChannelUseCase(),
        getDidShowOnboarding: GetDidShowOnboardingUseCaseProtocol = GetDidShowOnboardingUseCase(),
        getAppFlags: GetAppFlagsUseCaseProtocol = GetAppFlagsUseCase(),
        setAppFlags: SetAppFlagsUseCaseProtocol = SetAppFlagsUseCase()
    ) {
        self.subscribeToChannel = subscribeToChannel
        self.getDidShowOnboarding = getDidShowOnboarding
        self.setAppFlags = setAppFlags
        self.getAppFlags = getAppFlags
    }
    
    lazy var isFirstFeed: Bool = !getDidShowOnboarding()
    
    func onSubmit(with dismissAction: DismissAction) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: inputText) else {
            return
        }
        
        do {
            try await subscribeToChannel(with: url)
        } catch {
            isError = true
            return
        }
        
        var appFlags = getAppFlags()
        if appFlags.isNil {
            appFlags = AppFlags(didShowOnboarding: true)
        } else {
            appFlags?.didShowOnboarding = true
        }
        
        guard let appFlags else {
            dismissAction()
            return
        }
        
        setAppFlags(appFlags)
        dismissAction()
    }
    
    func cancel() {
        isError = false
        inputText = ""
    }
    
    func retry() {
        
    }
    
}
