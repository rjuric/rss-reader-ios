//
//  ArticlesListViewModelTests.swift
//  RSS ReaderTests
//
//  Created by rjuric on 30.04.2024..
//

import XCTest
@testable import RSS_Reader

final class ArticlesListViewModelTests: XCTestCase {
    var sut: ArticlesListViewModel!
    var repository: ChannelRepositoryStub!

    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = ChannelRepositoryStub()
        sut = ArticlesListViewModel(
            clearArticleCount: ClearNewArticleCountUseCase(channelRepository: repository),
            articles: [],
            publication: "Test Name",
            id: "Test id"
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        repository = nil
    }

    func test_onAppear_calls_repositoryMethod() throws {
        XCTAssertFalse(repository.clearNewArticlesCountCalled)
        
        sut.onAppear()
        
        XCTAssertTrue(repository.clearNewArticlesCountCalled)
        XCTAssertEqual(repository.clearNewArticlesCountCalledWith, ["Test id"])
    }
}
