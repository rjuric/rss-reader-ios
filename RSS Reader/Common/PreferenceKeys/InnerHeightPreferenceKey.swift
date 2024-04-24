//
//  InnerHeightPreferenceKey.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
