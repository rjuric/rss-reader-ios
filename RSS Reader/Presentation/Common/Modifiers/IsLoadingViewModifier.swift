//
//  IsLoadingViewModifier.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct IsLoadingViewModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
                    .padding(16)
                    .background(Material.regular)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .opacity(isLoading ? 1 : 0)
                    .animation(.easeOut(duration: 0.16), value: isLoading)
            }
            
    }
}

extension View {
    func isLoading(_ isLoading: Bool) -> some View {
        self.modifier(IsLoadingViewModifier(isLoading: isLoading))
    }
}
