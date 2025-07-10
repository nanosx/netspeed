
import SwiftUI

struct StatusItemView: View {
    // The view now observes the AppState object.
    @ObservedObject var appState: AppState

    var body: some View {
        // The text is now bound directly to the properties of the appState.
        Text("↑ \(appState.uploadSpeed) | ↓ \(appState.downloadSpeed)")
            .font(.system(.caption, design: .monospaced))
            .frame(minWidth: 150, alignment: .center)
    }
}
