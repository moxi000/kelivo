import SwiftUI
import WebKit

// MARK: - HTMLPreviewView

/// A platform-adaptive WKWebView wrapper for rendering HTML content.
/// Uses `UIViewRepresentable` on iOS and `NSViewRepresentable` on macOS.
/// Commonly used for previewing HTML content from chat messages.

#if os(iOS)

struct HTMLPreviewView: UIViewRepresentable {
    let htmlContent: String
    let baseURL: URL?

    init(htmlContent: String, baseURL: URL? = nil) {
        self.htmlContent = htmlContent
        self.baseURL = baseURL
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let wrapped = Self.wrapHTML(htmlContent)
        webView.loadHTMLString(wrapped, baseURL: baseURL)
    }

    func makeCoordinator() -> HTMLPreviewCoordinator {
        HTMLPreviewCoordinator()
    }
}

#elseif os(macOS)

struct HTMLPreviewView: NSViewRepresentable {
    let htmlContent: String
    let baseURL: URL?

    init(htmlContent: String, baseURL: URL? = nil) {
        self.htmlContent = htmlContent
        self.baseURL = baseURL
    }

    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        let wrapped = Self.wrapHTML(htmlContent)
        webView.loadHTMLString(wrapped, baseURL: baseURL)
    }

    func makeCoordinator() -> HTMLPreviewCoordinator {
        HTMLPreviewCoordinator()
    }
}

#endif

// MARK: - HTML Wrapper

extension HTMLPreviewView {
    /// Wraps raw HTML content in a full document with responsive viewport
    /// and system-matched color scheme styling.
    static func wrapHTML(_ content: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
            <style>
                :root {
                    color-scheme: light dark;
                }
                body {
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    font-size: 16px;
                    line-height: 1.5;
                    padding: 16px;
                    margin: 0;
                    color: var(--text-color, #000);
                    background: transparent;
                    word-wrap: break-word;
                    overflow-wrap: break-word;
                }
                @media (prefers-color-scheme: dark) {
                    body { color: #f0f0f0; }
                }
                img { max-width: 100%; height: auto; }
                pre {
                    background: rgba(128,128,128,0.1);
                    padding: 12px;
                    border-radius: 8px;
                    overflow-x: auto;
                }
                code {
                    font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
                    font-size: 14px;
                }
            </style>
        </head>
        <body>
            \(content)
        </body>
        </html>
        """
    }
}

// MARK: - Coordinator

/// Navigation delegate that prevents external link navigation within the preview.
final class HTMLPreviewCoordinator: NSObject, WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if navigationAction.navigationType == .linkActivated,
           let url = navigationAction.request.url {
            // Open external links in the system browser
            #if os(iOS)
            UIApplication.shared.open(url)
            #elseif os(macOS)
            NSWorkspace.shared.open(url)
            #endif
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - Preview

#Preview {
    HTMLPreviewView(
        htmlContent: """
        <h1>Hello, World</h1>
        <p>This is a <strong>preview</strong> of HTML content rendering.</p>
        <pre><code>let x = 42</code></pre>
        """
    )
    .frame(width: 400, height: 300)
}
