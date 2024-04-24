//
//  WebView.swift
//  RSS Reader
//
//  Created by rjuric on 24.04.2024..
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}

#Preview {
    WebView(url: URL(string: "https://medium.com/@rjuric/tournament-brackets-in-swiftui-ccdd2266fe62")!)
}
