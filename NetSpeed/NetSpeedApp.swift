
import SwiftUI

@main
struct NetSpeedApp: App {
    // By using the AppDelegateAdaptor, we are handing off the app's lifecycle
    // to the AppDelegate, which will set up our menu bar item.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // The Settings scene is required for a menu bar app that doesn't
        // have a main window. It ensures the app can run without one.
        Settings { }
    }
}
