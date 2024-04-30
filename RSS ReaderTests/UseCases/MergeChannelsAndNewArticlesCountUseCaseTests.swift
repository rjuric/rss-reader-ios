//
//  MergeChannelsAndNewArticlesCountUseCaseTests.swift
//  RSS ReaderTests
//
//  Created by rjuric on 29.04.2024..
//

import XCTest
@testable import RSS_Reader

final class MergeChannelsAndNewArticlesCountUseCaseTests: XCTestCase {
    private var sut: MergeChannelsAndNewArticlesCountUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MergeChannelsAndNewArticlesCountUseCase()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_returnsEmpty_on_noInput() throws {
        let result = sut([], with: [:])
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_returns0NewArticles_on_noChanges() throws {
        let channels = [
            Channel(
                title: "Channel 1",
                description: "Description 1",
                articles: [],
                url: URL(string: "https://en.wikipedia.org/wiki/Special:Random")!
            )
        ]
        
        let result = sut(channels, with: [:])
        XCTAssertEqual(result.first?.articleCount, 0)
    }
    
    func test_returnsCorrectNumber_on_correctInput() throws {
        let channels = [
            Channel(
                title: "Channel 1",
                description: "Description 1",
                articles: [],
                url: URL(string: "https://en.wikipedia.org/wiki/Special:Random")!
            )
        ]
        
        let result = sut(channels, with: ["https://en.wikipedia.org/wiki/Special:Random":1])
        XCTAssertEqual(result.first?.articleCount, 1)
    }
    
    func test_returnsCorrectNumbers_on_correctInputs() throws {
        let channels = [
            Channel(
                title: "Channel 1",
                description: "Description 1",
                articles: [],
                url: URL(string: "https://en.wikipedia.org/wiki/Special:Random")!
            ),
            Channel(
                title: "Channel 2",
                description: "Description 2",
                articles: [],
                url: URL(string: "https://en.wikipedia.org/wiki/Special:Random2")!
            )
        ]
        
        let results = sut(channels, with: ["https://en.wikipedia.org/wiki/Special:Random":1])
        let newArticles = results.map(\.articleCount)
        XCTAssertEqual(newArticles, [1, 0])
    }

}
