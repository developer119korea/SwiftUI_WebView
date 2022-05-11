import Foundation
import Combine

typealias WEB_NAVIGATION = WebViewModel.NAVIGATION

class WebViewModel: ObservableObject {
    enum NAVIGATION {
        case BACK, FORWARD, REFRESH
    }
    
    enum URL_TYPE {
        case NAVER
        case GOOGLE
        case DEVELOPER119
        var url : URL? {
            switch self {
            case.NAVER: return URL(string: "https://www.naver.com")
            case.GOOGLE: return URL(string: "https://www.google.com")
            case.DEVELOPER119: return URL(string: "https://developer119korea.github.io/simple_js_alert")
            }
        }
    }
    
    var changeUrlSubject = PassthroughSubject<WebViewModel.URL_TYPE, Never>()
    var webNavigationSubject = PassthroughSubject<WEB_NAVIGATION, Never>()
}
