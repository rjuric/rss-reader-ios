//
//  ContentView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FeedNavigationWrapper {
            FeedListView()
        }
    }
}

#Preview {
    ContentView()
}
