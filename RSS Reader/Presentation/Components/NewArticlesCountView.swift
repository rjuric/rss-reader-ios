//
//  NewArticlesCountView.swift
//  RSS Reader
//
//  Created by rjuric on 27.04.2024..
//

import SwiftUI

struct NewArticlesCountView: View {
    let count: Int
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Text("\(count)")
            .foregroundStyle(Color.white)
            .font(.caption)
            .padding(2)
            .background(Color.indigo)
            .clipShape(Circle())
    }
}

#Preview {
    NewArticlesCountView(count: 3)
}
