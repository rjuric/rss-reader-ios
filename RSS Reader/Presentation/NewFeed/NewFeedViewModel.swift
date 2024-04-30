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
    private let requestNotificationsAuthorization: RequestNotificationAuthorizationUseCaseProtocol
    
    var isSubmitDisabled: Bool {
        isLoading || inputText.isEmpty || !isValidUrl
    }
    
    private var isValidUrl: Bool {
        guard let url = URL(string: inputText) else { return false }
        
        guard let scheme = url.scheme,
              scheme == Constants.SupportedUrlSchemes.https || scheme == Constants.SupportedUrlSchemes.http
        else {
            return false
        }
        
        return true
    }
    
    init(
        subscribeToChannel: SubscribeToChannelUseCaseProtocol = SubscribeToChannelUseCase(),
        getDidShowOnboarding: GetDidShowOnboardingUseCaseProtocol = GetDidShowOnboardingUseCase(),
        getAppFlags: GetAppFlagsUseCaseProtocol = GetAppFlagsUseCase(),
        setAppFlags: SetAppFlagsUseCaseProtocol = SetAppFlagsUseCase(),
        requestNotificationAuthorization: RequestNotificationAuthorizationUseCaseProtocol = RequestNotificationAuthorizationUseCase()
    ) {
        self.subscribeToChannel = subscribeToChannel
        self.getDidShowOnboarding = getDidShowOnboarding
        self.setAppFlags = setAppFlags
        self.getAppFlags = getAppFlags
        self.requestNotificationsAuthorization = requestNotificationAuthorization
    }
    
    lazy var isFirstFeed: Bool = !getDidShowOnboarding()
    
    func onSubmit(with dismissAction: () -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: inputText) else {
            return
        }
        
        do {
            try await subscribeToChannel(with: url)
            await requestNotificationsAuthorization()
        } catch {
            isError = true
            return
        }
        
        var appFlags = getAppFlags()
        if appFlags.isNil {
            appFlags = AppFlags(didShowOnboarding: true)
        } else if appFlags?.didShowOnboarding == false {
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
}
