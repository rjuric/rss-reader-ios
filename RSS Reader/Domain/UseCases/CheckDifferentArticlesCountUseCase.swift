//
//  CheckDifferentArticlesCountUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol CheckDifferentArticlesCountUseCaseProtocol {
    func execute(from oldArticles: [Article], to newArticles: [Article]) -> Int
}

extension CheckDifferentArticlesCountUseCaseProtocol {
    func callAsFunction(from oldArticles: [Article], to newArticles: [Article]) -> Int {
        execute(from: oldArticles, to: newArticles)
    }
}

struct CheckDifferentArticlesCountUseCase: CheckDifferentArticlesCountUseCaseProtocol {
    func execute(from oldArticles: [Article], to newArticles: [Article]) -> Int {
        return newArticles.filter({ !oldArticles.contains($0) }).count
    }
}
