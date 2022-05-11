import SwiftUI

@main
struct SwiftUI_WebViewApp: App {
    private var webviewModel = WebViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(webviewModel)
        }
    }
}
