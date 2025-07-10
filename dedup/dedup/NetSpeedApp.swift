import SwiftUI

@main
struct NetSpeedApp: App {
    // This connects our AppDelegate to the SwiftUI app lifecycle.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // The Settings scene is required for a menu bar app that doesn't
        // have a main window. It ensures the app can run without one.
        Settings { }
    }
}