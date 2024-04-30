//
//  GetDidShowOnboardingUseCase.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import Foundation

protocol GetDidShowOnboardingUseCaseProtocol {
    func execute() -> Bool
}

extension GetDidShowOnboardingUseCaseProtocol {
    func callAsFunction() -> Bool {
        execute()
    }
}

struct GetDidShowOnboardingUseCase: GetDidShowOnboardingUseCaseProtocol {
    var getAppFlags: GetAppFlagsUseCaseProtocol = GetAppFlagsUseCase()
    
    func execute() -> Bool {
        let flags = getAppFlags()
        
        return flags?.didShowOnboarding == true
    }
}

#if DEBUG
struct PreviewGetDidShowOnboardingUseCase: GetDidShowOnboardingUseCaseProtocol {
    var returnValue: Bool
    
    func execute() -> Bool {
        returnValue
    }
}
#endif
