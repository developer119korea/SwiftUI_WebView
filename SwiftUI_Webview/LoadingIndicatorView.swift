import Foundation
import SwiftUI
import UIKit

struct LoadingIndicatorView: UIViewRepresentable {
    
    var isAniming: Bool = true
    var color: UIColor = .white
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Self>) {
        isAniming ? uiView.startAnimating() : uiView.stopAnimating()
        uiView.style = .large
        uiView.color = color
    }
}
