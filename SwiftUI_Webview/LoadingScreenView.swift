import Foundation
import SwiftUI

struct LoadingScreenView: View {
    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            LoadingIndicatorView()
        })
    }
}
