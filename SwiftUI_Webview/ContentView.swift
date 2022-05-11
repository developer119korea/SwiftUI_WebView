import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var webviewModel: WebViewModel
    @State var textString = ""
    @State var shouldShowAlert = false
    @State var isLoading = false
    @State var webTitle: String = ""
    @State var jsAlert: JsAlert?
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    WebView(urlToLoad: "https://developer119korea.github.io/simple_js_alert")
                    webViewBottomTabbar
                }
                .navigationTitle(Text(webTitle))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { siteMenu }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("iOS -> JS")
                            self.shouldShowAlert.toggle()
                        }, label: {
                            Text("iOS -> JS")
                        })
                    }
                }
                .alert(item:$jsAlert, content: { alert in
                    createAlert(alert)
                })
                if self.shouldShowAlert { createTextAlert() }
                if self.isLoading { LoadingScreenView() }
            }
            .onReceive(webviewModel.webSiteTitleSubject, perform: { receiveWebTitle in
                print("ContentView - webTitle: ", receiveWebTitle)
                self.webTitle = receiveWebTitle
            })
            .onReceive(webviewModel.jsAlertEvent, perform: { jsAlert in
                print("ContentView - jsAlert: ", jsAlert)
                self.jsAlert = jsAlert
            })
            .onReceive(webviewModel.shouldShowIndicator, perform: { isLoading in
                print("ContentView - isLoading: ", isLoading)
                self.isLoading = isLoading
            })
        }
    }
    
    var siteMenu: some View {
        Text("사이트 이동")
            .foregroundColor(.blue)
            .contextMenu(menuItems: {
                Button(action: {
                    print("developer119 웹뷰 이동")
                    self.webviewModel.changeUrlSubject.send(.DEVELOPER119)
                }, label: {
                    Text("developer119 웹뷰 이동")
                    Image("developer119")
                })
                Button(action: {
                    print("네이버 이동")
                    self.webviewModel.changeUrlSubject.send(.NAVER)
                }, label: {
                    Text("네이버 이동")
                    Image("naver")
                })
                Button(action: {
                    print("google 이동")
                    self.webviewModel.changeUrlSubject.send(.GOOGLE)
                }, label: {
                    Text("google 이동")
                    Image("google")
                })
            })
    }

    var webViewBottomTabbar: some View {
        VStack {
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    print("뒤로가기")
                    self.webviewModel.webNavigationSubject.send(.BACK)
                }, label: {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 20))
                })
                Group{
                    Spacer()
                    Divider()
                    Spacer()
                }
                Button(action: {
                    print("앞으로 가기")
                    self.webviewModel.webNavigationSubject.send(.FORWARD)
                }, label: {
                    Image(systemName: "arrow.forward")
                        .font(.system(size: 20))
                })
                Group{
                    Spacer()
                    Divider()
                    Spacer()
                }
                Button(action: {
                    print("새로고침")
                    self.webviewModel.webNavigationSubject.send(.REFRESH)
                }, label: {
                    Image(systemName: "goforward")
                        .font(.system(size: 20))
                })
                Spacer()
            }.frame(height: 45)
            Divider()
        }
    }
}

extension ContentView {
    func createTextAlert() -> MyTextAlertView {
        MyTextAlertView(textString: $textString, showAlert: $shouldShowAlert, title: "iOS -> JS", message: "")
    }
    
    func createAlert(_ alert: JsAlert) -> Alert {
        Alert(title: Text(alert.type.description),
              message: Text(alert.message),
              dismissButton: .default(Text("확인"), action: {
                print("알림창 확인 버튼이 클릭되었다.")
        }))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
