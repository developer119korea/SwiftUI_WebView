//
//  SwiftUI_WebviewApp.swift
//  SwiftUI_Webview
//
//  Created by Youngwan Cho on 2022/05/10.
//

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
