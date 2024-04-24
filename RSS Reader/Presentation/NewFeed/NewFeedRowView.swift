//
//  NewFeedRowView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct NewFeedRowView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "plus.circle")
                .resizable()
                .scaledToFit()
                .padding(20)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Ran out of things to read?")
                    .font(.headline)
                
                Text("Tap here to add another feed.")
                    .font(.subheadline)
                    .opacity(0.8)
            }
            .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    NewFeedRowView()
}
