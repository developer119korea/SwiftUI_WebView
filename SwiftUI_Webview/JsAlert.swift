import Foundation

struct JsAlert : Identifiable {
    enum TYPE: CustomStringConvertible {
        case JS_ALERT, JS_BRIDGE
        var description: String {
            switch self {
            case .JS_ALERT: return "JS_ALERT"
            case .JS_BRIDGE: return "JS_BRIDGE"
            }
        }
    }
    
    let id: UUID = UUID()
    var message: String = ""
    var type: TYPE
    
    init(_ message: String? = nil, _ type: TYPE) {
        self.message = message ?? "메시지 없음"
        self.type = type
    }
}
