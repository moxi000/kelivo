import SwiftUI
import WebKit

/// A cross-platform WKWebView wrapper for rendering HTML content.
#if os(iOS)
struct WebViewWrapper: UIViewRepresentable {
    let htmlContent: String?
    let url: URL?

    init(html: String) {
        self.htmlContent = html
        self.url = nil
    }

    init(url: URL) {
        self.htmlContent = nil
        self.url = url
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let html = htmlContent {
            webView.loadHTMLString(html, baseURL: nil)
        } else if let url {
            webView.load(URLRequest(url: url))
        }
    }
}
#elseif os(macOS)
struct WebViewWrapper: NSViewRepresentable {
    let htmlContent: String?
    let url: URL?

    init(html: String) {
        self.htmlContent = html
        self.url = nil
    }

    init(url: URL) {
        self.htmlContent = nil
        self.url = url
    }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        if let html = htmlContent {
            webView.loadHTMLString(html, baseURL: nil)
        } else if let url {
            webView.load(URLRequest(url: url))
        }
    }
}
#endif

/// A full-screen web view page.
struct WebViewPage: View {
    let title: String
    let html: String?
    let url: URL?

    init(title: String, html: String) {
        self.title = title
        self.html = html
        self.url = nil
    }

    init(title: String, url: URL) {
        self.title = title
        self.html = nil
        self.url = url
    }

    var body: some View {
        Group {
            if let html {
                WebViewWrapper(html: html)
            } else if let url {
                WebViewWrapper(url: url)
            }
        }
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        WebViewPage(title: "Preview", html: "<h1>Hello World</h1><p>This is a test.</p>")
    }
}
