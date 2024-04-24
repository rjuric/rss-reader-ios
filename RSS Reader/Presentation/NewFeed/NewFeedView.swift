//
//  NewFeedView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct NewFeedView: View {
    @ObservedObject var viewModel: NewFeedViewModel

    @FocusState private var isFocused: Bool
    @State private var sheetHeight: CGFloat = .zero
        
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 24)
            
            Text("Add a new feed")
                .font(.title)
            
            Spacer()
                .frame(height: 32)
            
            if viewModel.isFirstFeed {
                Text("Before we start...")
                    .font(.largeTitle)
                
                Text("You need to add your first RSS feed.")
                    .opacity(0.8)
                
                Spacer()
                    .frame(height: 24)
            }
            
            TextField("Tap to enter your URL", text: $viewModel.inputText)
                .padding(8)
                .background(Material.ultraThin)
                .foregroundStyle(.foreground)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .focused($isFocused)
            
            Spacer()
                .frame(height: 24)
            
            Button(
                action: {
                    Task(priority: .userInitiated) {
                        await viewModel.onSubmit()
                    }
                }, label: {
                    ZStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .opacity(viewModel.isLoading ? 1 : 0)
                        
                        Text("Submit")
                            .opacity(viewModel.isLoading ? 0 : 1)
                    }
                }
            )
            .buttonStyle(BorderedProminentButtonStyle())
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal, 20)
        .overlay {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
            }
        }
        .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
            sheetHeight = newHeight
        }
        .presentationDetents([.height(sheetHeight)])
        .onTapGesture {
            isFocused = false
        }
    }
}

#Preview {
    Text("Placeholder")
        .sheet(isPresented: .constant(true)) {
            NewFeedView(viewModel: NewFeedViewModel(isFirstFeed: false))
        }
}

#Preview {
    Text("Placeholder")
        .sheet(isPresented: .constant(true)) {
            NewFeedView(viewModel: NewFeedViewModel(isFirstFeed: false))
        }
}