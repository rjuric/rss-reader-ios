//
//  CheckDifferentArticlesCountUseCaseTests.swift
//  RSS ReaderTests
//
//  Created by rjuric on 29.04.2024..
//

import XCTest
@testable import RSS_Reader

final class CheckDifferentArticlesCountUseCaseTests: XCTestCase {
    var sut: CheckDifferentArticlesCountUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CheckDifferentArticlesCountUseCase()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_returns0_on_sameArticles() throws {
        
        let oldArticles: [Article] = [
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
            )
        ]
        let newArticles = oldArticles
        
        XCTAssertEqual(sut(from: oldArticles, to: newArticles), 0)
    }
    
    func test_returns1_on_newArticle() throws {
        let oldArticles: [Article] = [
            Article(
                title: "[ŠOK] Prebio dvojicu ispred Velveta",
                image: URL(string: "https://picsum.photos/200")!,
                description: "Pogledajte što je napravio"
            ),
            Article(
                title: "[VIDEO] Raspudići napuštaju Most",
                image: nil,
                description: "Tragedija hrvatskog naroda"
            )
        ]
        let newArticles = [
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
            )
        ]
        
        XCTAssertEqual(sut(from: oldArticles, to: newArticles), 1)
    }
    
    func test_returns0_on_lessNewArticles() throws {
        let oldArticles: [Article] = [
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
            )
        ]
        let newArticles = [
            Article(
                title: "[ŠOK] Prebio dvojicu ispred Velveta",
                image: URL(string: "https://picsum.photos/200")!,
                description: "Pogledajte što je napravio"
            )
        ]
        
        XCTAssertEqual(sut(from: oldArticles, to: newArticles), 0)
    }

}
