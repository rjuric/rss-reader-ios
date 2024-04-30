//
//  NewFeedViewModelTests.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import XCTest
@testable import RSS_Reader

@MainActor
final class NewFeedViewModelTests: XCTestCase {
    var sut: NewFeedViewModel!
    var channelRepository: ChannelRepositoryStub!
    var appFlagsPersistenceService: AppFlagsPersistenceServiceStub!
    var requestNotifications: RequestNotificationAuthorizationUseCaseStub!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        channelRepository = ChannelRepositoryStub()
        appFlagsPersistenceService = AppFlagsPersistenceServiceStub()
        requestNotifications = RequestNotificationAuthorizationUseCaseStub()
        sut = NewFeedViewModel(
            subscribeToChannel: SubscribeToChannelUseCase(channelRepository: channelRepository),
            getDidShowOnboarding: GetDidShowOnboardingUseCase(getAppFlags: GetAppFlagsUseCase(persistenceService: appFlagsPersistenceService)),
            getAppFlags: GetAppFlagsUseCase(persistenceService: appFlagsPersistenceService),
            setAppFlags: SetAppFlagsUseCase(persistenceService: appFlagsPersistenceService),
            requestNotificationAuthorization: requestNotifications
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        channelRepository = nil
        appFlagsPersistenceService = nil
        requestNotifications = nil
    }

    func test_isFirstFeedTrue_on_noFlags() throws {
        appFlagsPersistenceService.fetchResult = nil
        
        let result = sut.isFirstFeed
        XCTAssertTrue(result)
    }
    
    func test_isFirstFeedTrue_on_falseFlag() throws {
        appFlagsPersistenceService.fetchResult = AppFlags(didShowOnboarding: false)
        
        let result = sut.isFirstFeed
        XCTAssertTrue(result)
    }
    
    func test_isFirstFeedFalse_on_trueFlag() throws {
        appFlagsPersistenceService.fetchResult = AppFlags(didShowOnboarding: true)
        
        let result = sut.isFirstFeed
        XCTAssertFalse(result)
    }
    
    func test_savesFlags_on_submitSuccess() async throws {
        sut.inputText = "https://example.com"
        sut.isLoading = true
        
        await sut.onSubmit(with: {})
        
        XCTAssertTrue(appFlagsPersistenceService.saveWasCalled)
        XCTAssertEqual(appFlagsPersistenceService.saveCalledWith?.didShowOnboarding, true)
    }

    func test_submitIsDisabled_on_emptyStringInput() throws {
        sut.inputText = ""
        
        XCTAssertTrue(sut.isSubmitDisabled)
    }
    
    func test_submitIsDisabled_on_incorrectSchemeInput() throws {
        sut.inputText = "wss://example.com"
        
        XCTAssertTrue(sut.isSubmitDisabled)
    }
    
    func test_submitIsDisabled_on_loadingTrue() throws {
        sut.inputText = "https://example.com"
        sut.isLoading = true
        
        XCTAssertTrue(sut.isSubmitDisabled)
    }
    
    func test_submitIsEnabled_on_everythingCorrect() throws {
        sut.inputText = "https://example.com"
        sut.isLoading = false
        
        XCTAssertFalse(sut.isSubmitDisabled)
    }
    
    func test_submitNotCalled_on_invalidUrl() async throws {
        sut.isLoading = false
        
        await sut.onSubmit(with: {})
        
        XCTAssertFalse(channelRepository.subscribeToFeedCalled)
    }
    
    func test_submitCalled_on_validUrl() async throws {
        sut.inputText = "https://example.com"
        sut.isLoading = false
        
        await sut.onSubmit(with: {})
        
        XCTAssertTrue(channelRepository.subscribeToFeedCalled)
    }
    
    func test_showsError_onSubmitError() async throws {
        sut.inputText = "https://example.com"
        sut.isLoading = false
        channelRepository.subscribeToFeedReturnValue = .failure(RssReaderError.wrongFeedFormat)
        
        await sut.onSubmit(with: {})
        
        XCTAssertTrue(sut.isError)
    }
    
    func test_doesntDismiss_onSubmitError() async throws {
        sut.inputText = "https://example.com"
        sut.isLoading = false
        channelRepository.subscribeToFeedReturnValue = .failure(RssReaderError.wrongFeedFormat)
        
        var didDismiss = false
        await sut.onSubmit(with: { didDismiss = true })
        
        XCTAssertTrue(sut.isError)
        XCTAssertFalse(didDismiss)
    }
    
    func test_dismisses_onSubmitSucces() async throws {
        sut.inputText = "https://example.com"
        sut.isLoading = false
        var didDismiss = false
        
        await sut.onSubmit(with: { didDismiss = true })
        
        XCTAssertFalse(sut.isError)
        XCTAssertTrue(didDismiss)
    }
    
    func test_requestsNotifications_onSubmitSuccess() async throws {
        sut.inputText = "https://example.com"
        sut.isLoading = false
        
        await sut.onSubmit(with: { })
        
        XCTAssertFalse(sut.isError)
        XCTAssertTrue(requestNotifications.wasCalled)
    }
    
    func test_doesntRequestNotifications_onSubmitFailure() async throws {
        channelRepository.subscribeToFeedReturnValue = .failure(RssReaderError.wrongFeedFormat)
        sut.inputText = "https://example.com"
        sut.isLoading = false
        
        await sut.onSubmit(with: { })
        
        XCTAssertTrue(sut.isError)
        XCTAssertFalse(requestNotifications.wasCalled)
    }
    
    func test_cancelClearsInput() throws {
        sut.inputText = "some input"
        sut.isError = true
        
        XCTAssertTrue(sut.isError)
        XCTAssertFalse(sut.inputText.isEmpty)
        
        sut.cancel()
        
        XCTAssertFalse(sut.isError)
        XCTAssertTrue(sut.inputText.isEmpty)
    }
}
