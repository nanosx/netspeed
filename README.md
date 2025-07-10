# NetSpeed

A minimal and elegant network speed monitor for macOS, designed to live in your menu bar. It displays real-time upload and download speeds (in MB/s) and offers options for update intervals and launching at login.

## Features

*   **Real-time Speed Display:** Shows current upload (↑) and download (↓) speeds in MB/s directly in your macOS menu bar.
*   **Minimal UI:** Clean and unobtrusive design.
*   **Configurable Update Interval:** Choose between 1, 2, or 5-second update intervals from the menu.
*   **Launch at Login:** Option to automatically start the application when your Mac boots up.
*   **Lightweight:** Built natively for macOS using Swift and SwiftUI.


### Build from Source 
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/nanosx/netspeed.git
    cd netspeed
    ```
2.  **Open the project in Xcode:**
    ```bash
    open dedup.xcodeproj
    ```
    *(Note: The project is named `dedup` internally due to initial setup, but the app is `NetSpeed`)*
3.  **Set Deployment Target:** In Xcode, select the `dedup` target, go to the `General` tab, and ensure the `macOS Deployment Target` is set to `13.0` or higher.
4.  **Link ServiceManagement.framework:**
    *   In Xcode, select the `dedup` target, go to the `General` tab.
    *   Scroll down to `Frameworks, Libraries, and Embedded Content`.
    *   Click the `+` button and add `ServiceManagement.framework`. Ensure its "Embed" setting is "Do Not Embed".
5.  **Set "Application is agent (UIElement)":**
    *   In Xcode, select the `dedup` target, go to the `Info` tab.
    *   Add a new row (if it doesn't exist) and set `Application is agent (UIElement)` to `YES`.
6.  **Clean Derived Data (if you encounter build issues):**
    *   Go to `File > Project Settings...` (or `Workspace Settings...`).
    *   Click the arrow next to the `Derived Data` path to open it in Finder.
    *   Delete the folder starting with `dedup-` (or `NetSpeed-`).
    *   Quit and restart Xcode.
7.  **Build and Run:** Select `Any Mac (Apple Silicon, Intel)` as the target and press `Cmd+R` to build and run the application.

## Usage

Once launched, the NetSpeed monitor will appear in your macOS menu bar.

*   **Speed Display:** You will see something like `↑ 0.5 MB/s | ↓ 12.3 MB/s` indicating your current upload and download speeds.
*   **Menu Options:** Click on the menu bar item to reveal a dropdown menu with the following options:
    *   **Start at Login:** Toggle this to make the app launch automatically when you log in.
    *   **Update Interval:** A submenu to choose how frequently the speed display updates (1, 2, or 5 seconds). Your selection will be saved.
    *   **Quit:** Exit the application.

## Troubleshooting

*   **App not appearing in menu bar:** Ensure "Application is agent (UIElement)" is set to `YES` in your Xcode project's Info tab.
*   **`SMAppService` errors:** Verify your macOS Deployment Target is 13.0+ and `ServiceManagement.framework` is correctly linked (and "Do Not Embed"). If issues persist, try cleaning Derived Data and restarting Xcode.
*   **`EXC_BAD_ACCESS` crash:** This indicates an issue with reading network interface data. Ensure your `NetworkMonitor.swift` matches the latest version provided, which includes robust checks for `AF_LINK` interfaces.

## Contributing

Feel free to open issues or submit pull requests if you have suggestions or improvements!

## License

This project is open-source and available under the [MIT License](LICENSE).
