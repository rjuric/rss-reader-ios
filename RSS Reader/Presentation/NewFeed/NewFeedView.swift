//
//  NewFeedView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI

struct NewFeedView: View {
    @ObservedObject var viewModel: NewFeedViewModel

    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isFocused: Bool
    @State private var sheetHeight: CGFloat = .zero
        
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 24)
            
            Text("NewFeedView.Title")
                .font(.title)
            
            Spacer()
                .frame(height: 32)
            
            if viewModel.isFirstFeed {
                Text("NewFeedView.Onboarding.Title")
                    .font(.largeTitle)
                
                Text("NewFeedView.Onboarding.Subtitle")
                    .opacity(0.8)
                
                Spacer()
                    .frame(height: 24)
            }
            
            TextField("NewFeedView.TextField.Prompt", text: $viewModel.inputText)
                .padding(8)
                .background(Material.ultraThin)
                .foregroundStyle(.foreground)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .focused($isFocused)
                .keyboardType(.URL)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.indigo, lineWidth: 2)
                }
                .shadow(color: .indigo, radius: 8)
            
            Spacer()
                .frame(height: 24)
            
            Button(
                action: submit,
                label: {
                    ZStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .opacity(viewModel.isLoading ? 1 : 0)
                        
                        Text("NewFeedView.Button.Title")
                            .opacity(viewModel.isLoading ? 0 : 1)
                    }
                }
            )
            .buttonStyle(BorderedProminentButtonStyle())
            .disabled(viewModel.isSubmitDisabled)
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
        .interactiveDismissDisabled(viewModel.isFirstFeed)
        .presentationBackground(Material.thick)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
        }
        .alert(
            "Common.Error.Title",
            isPresented: $viewModel.isError,
            actions: {
                Button("Common.Retry", action: submit)
                Button("Common.Cancel", action: viewModel.cancel)
            },
            message: {
                Text("Common.Error.Description")
            }
        )
    }
    
    private func submit() {
        Task {
            await viewModel.onSubmit(with: { dismiss() })
        }
    }
}

#Preview {
    let subscribeToChannelUC = PreviewSubscribeToChannelUseCase(isErroring: false)
    let getDidShowOnboardingUC = PreviewGetDidShowOnboardingUseCase(returnValue: true)
    let getAppFlagsUC = PreviewGetAppFlagsUseCase(returnValue: nil)
    let setAppFlagsUC = PreviewSetAppFlagsUseCase()
    let requestAuthorizationUC = PreviewRequestNotificationAuthorizationUseCase()
    
    return Text("Placeholder")
        .sheet(isPresented: .constant(true)) {
            NewFeedView(
                viewModel: NewFeedViewModel(
                    subscribeToChannel: subscribeToChannelUC,
                    getDidShowOnboarding: getDidShowOnboardingUC,
                    getAppFlags: getAppFlagsUC,
                    setAppFlags: setAppFlagsUC,
                    requestNotificationAuthorization: requestAuthorizationUC
                )
            )
        }
}
