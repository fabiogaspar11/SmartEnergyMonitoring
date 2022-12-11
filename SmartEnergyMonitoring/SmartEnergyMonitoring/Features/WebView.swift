//
//  SwiftUIWebView.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 07/12/2022.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let webView: WKWebView
    
    init(accessToken: String) {
        webView = WKWebView(frame: .zero)
        webView.load(URLRequest(url: URL(string: "https://daniel-carreira.github.io/sem-ar?token=\(accessToken)")!))
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
