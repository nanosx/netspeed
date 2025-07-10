import SwiftUI
import ServiceManagement

// Create a simple observable object to hold our state.
// This is a better pattern for SwiftUI views to observe.
class AppState: ObservableObject {
    @Published var uploadSpeed: String = "-- MB/s"
    @Published var downloadSpeed: String = "-- MB/s"
}

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var statusItem: NSStatusItem!
    var appState = AppState()
    
    private var networkMonitor = NetworkMonitor()
    private var timer: Timer?
    // Default to 2 seconds, but we will load the saved value.
    private var updateInterval: TimeInterval = 2.0

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Load the saved interval, or use the default.
        self.updateInterval = UserDefaults.standard.double(forKey: "updateInterval")
        if self.updateInterval == 0 { self.updateInterval = 2.0 } // Default if not set
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            let hostingView = NSHostingView(rootView: StatusItemView(appState: appState))
            button.addSubview(hostingView)
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: button.topAnchor),
                hostingView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                hostingView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            ])
        }

        setupMenu()
        startTimer()
    }

    func startTimer() {
        // Invalidate any existing timer before starting a new one.
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.updateNetworkSpeed()
        }
    }

    @objc func updateNetworkSpeed() {
        let speeds = networkMonitor.getNetworkSpeed()
        // Update the state on the main thread
        DispatchQueue.main.async {
            self.appState.uploadSpeed = speeds.upload
            self.appState.downloadSpeed = speeds.download
        }
    }
    
    func setupMenu() {
        let menu = NSMenu()
        menu.delegate = self
        
        menu.addItem(withTitle: "Start at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        
        let intervalMenu = NSMenu()
        intervalMenu.addItem(withTitle: "1 Second", action: #selector(setUpdateInterval), keyEquivalent: "").tag = 1
        intervalMenu.addItem(withTitle: "2 Seconds", action: #selector(setUpdateInterval), keyEquivalent: "").tag = 2
        intervalMenu.addItem(withTitle: "5 Seconds", action: #selector(setUpdateInterval), keyEquivalent: "").tag = 5
        
        let intervalMenuItem = NSMenuItem(title: "Update Interval", action: nil, keyEquivalent: "")
        intervalMenuItem.submenu = intervalMenu
        menu.addItem(intervalMenuItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        statusItem.menu = menu
    }
    
    // This delegate method is called right before the menu is shown.
    func menuWillOpen(_ menu: NSMenu) {
        // Update the "Start at Login" checkmark
        let isEnabled = SMAppService.main.status == .enabled
        menu.items.first(where: { $0.action == #selector(toggleLaunchAtLogin) })?.state = isEnabled ? .on : .off
        
        // Update the interval checkmark
        if let intervalSubmenu = menu.items.first(where: { $0.title == "Update Interval" })?.submenu {
            for item in intervalSubmenu.items {
                item.state = item.tag == Int(self.updateInterval) ? .on : .off
            }
        }
    }

    @objc func toggleLaunchAtLogin() {
        do {
            if SMAppService.main.status == .enabled {
                try SMAppService.main.unregister()
            } else {
                try SMAppService.main.register()
            }
        } catch {
            print("Failed to update Start at Login setting: \(error)")
        }
    }
    
    @objc func setUpdateInterval(sender: NSMenuItem) {
        self.updateInterval = TimeInterval(sender.tag)
        // Save the setting for next time
        UserDefaults.standard.set(self.updateInterval, forKey: "updateInterval")
        // Restart the timer with the new interval
        startTimer()
    }
}