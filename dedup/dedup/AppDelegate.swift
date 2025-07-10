
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Hide the main app window and dock icon
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        NSApp.setActivationPolicy(.accessory)


        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            let hostingView = NSHostingView(rootView: StatusItemView())
            
            // Set a frame for the hosting view to give it an initial size
            hostingView.frame = NSRect(x: 0, y: 0, width: 150, height: 22)
            
            button.addSubview(hostingView)
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            
            // Corrected constraints
            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: button.topAnchor),
                hostingView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                hostingView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
            ])
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Start at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    @objc func toggleLaunchAtLogin() {
        // Implement launch at login logic here
        print("Toggled Launch at Login")
    }
}
