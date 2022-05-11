import SwiftUI
import WebKit
import Combine
import Foundation

struct WebView: UIViewRepresentable {
    @EnvironmentObject var viewModel: WebViewModel
    
    var urlToLoad: String

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }

        // 웹뷰 인스턴스 생성
        let webview = WKWebView(frame: .zero, configuration: createWebConfig())
        
        webview.uiDelegate = context.coordinator
        webview.navigationDelegate = context.coordinator
        webview.allowsBackForwardNavigationGestures = true

        // 웹뷰를 로드한다.
        webview.load(URLRequest(url: url))

        return webview
    }

    // 업데이트 ui view
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {

    }
    
    func createWebConfig() -> WKWebViewConfiguration {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let wkWebConfig = WKWebViewConfiguration()
        
        let userContentController = WKUserContentController()
        userContentController.add(self.makeCoordinator(), name: "callbackHandler")
        wkWebConfig.userContentController = userContentController
        wkWebConfig.preferences = preferences
        wkWebConfig.defaultWebpagePreferences.allowsContentJavaScript = true
        return wkWebConfig
    }
    
    func makeCoordinator() -> WebView.Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var webview: WebView
        var subscriptions = Set<AnyCancellable>()
        
        init(_ webview: WebView) {
            self.webview = webview
        }
    }
}

extension WebView.Coordinator : WKUIDelegate {
    
}

extension WebView.Coordinator : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.webview
            .viewModel
            .webNavigationSubject
            .sink{ (action: WEB_NAVIGATION) in
                print("들어온 네비게이션 액션 : \(action)")
                switch action {
                    case .BACK:
                        if webView.canGoBack {
                            webView.goBack()
                        }
                    case .FORWARD:
                        if webView.canGoForward {
                            webView.goForward()
                        }
                    case .REFRESH:
                        webView.reload()
                }
            }.store(in: &subscriptions)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (response, error) in
            if let error = error {
                print("document title error : \(error)")
            }
            if let title = response as? String {
                self.webview.viewModel.webSiteTitleSubject.send(title)
            }
        }

        self.webview
            .viewModel
            .changeUrlSubject
            .compactMap { $0.url }
            .sink{changedUrl in
                print ("변경된 url : \(changedUrl)")
                webView.load(URLRequest(url:changedUrl))
            }.store(in: &subscriptions)
        
        self.webview
            .viewModel
            .nativeToJsEvent
            .sink{ message in
                print("didFinish() called / nativeToJsEvent 이벤트 들어옴 / message: \(message)")
                webView.evaluateJavaScript("nativeToJsEventCall('\(message)');", completionHandler: { (result, error) in
                    if let result = result {
                        print("nativeToJs result 성공 : \(result)")
                    }
                    if let error = error {
                        print("nativeToJs result 실패 : \(error)")
                    }
                })
            }.store(in: &subscriptions)
    }
}

extension WebView.Coordinator : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            print("JSON 데이터가 웹으로 부터 옴: \(message.body)")
            if let receivedData: [String: String] = message.body as? Dictionary{
                print("receivedData: \(receivedData)")
                self.webview.viewModel.jsAlertEvent.send(JsAlert(receivedData["message"], .JS_BRIDGE))
            }
        }
    }
}

struct MyWebview_Previews: PreviewProvider {
    static var previews: some View {
        WebView(urlToLoad: "https://www.naver.com")
    }
}
 
