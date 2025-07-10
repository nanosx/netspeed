import SwiftUI

struct StatusItemView: View {
    @State private var uploadSpeed: String = "0 MB/s"
    @State private var downloadSpeed: String = "0 MB/s"
    private let networkMonitor = NetworkMonitor()
    private let timer = Timer.publish(every: 2, on: .main, in : .common).autoconnect()
    var body: some View {
        VStack {
            Text("↑ \(uploadSpeed) | ↓ \(downloadSpeed)")
        }
                .onReceive(timer) {
                    _ in
                    let speeds = networkMonitor.getNetworkSpeed()
                    self.uploadSpeed = speeds.upload
                    self.downloadSpeed = speeds.download
                }
    }
}

