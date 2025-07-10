
import Foundation

class NetworkMonitor {
    private var lastBytesIn: UInt64 = 0
    private var lastBytesOut: UInt64 = 0
    private var lastTimestamp: TimeInterval = 0

    // Initialize timestamp
    init() {
        lastTimestamp = Date().timeIntervalSince1970
    }

    func getNetworkSpeed() -> (upload: String, download: String) {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return ("-- MB/s", "-- MB/s") }
        defer { freeifaddrs(ifaddr) }

        var bytesIn: UInt64 = 0
        var bytesOut: UInt64 = 0

        var pointer = ifaddr
        while pointer != nil {
            guard let pointee = pointer?.pointee else {
                pointer = pointer?.pointee.ifa_next
                continue
            }

            let addr = pointee.ifa_addr.pointee
            // We are only interested in link-level interfaces (AF_LINK) for byte counts.
            guard addr.sa_family == AF_LINK else {
                pointer = pointee.ifa_next
                continue
            }

            // And we only look at the interfaces we care about (wired, wifi, cellular)
            let name = String(cString: pointee.ifa_name)
            if ["en0", "en1", "pdp_ip0"].contains(name) {
                // The data is stored in a if_data structure for AF_LINK addresses.
                if let data = pointee.ifa_data {
                    let if_data = data.bindMemory(to: if_data.self, capacity: 1)
                    bytesIn += UInt64(if_data.pointee.ifi_ibytes)
                    bytesOut += UInt64(if_data.pointee.ifi_obytes)
                }
            }

            pointer = pointee.ifa_next
        }

        let now = Date().timeIntervalSince1970
        let timeInterval = now - lastTimestamp

        // Avoid division by zero and nonsensical speeds on the first run or after a resume
        if timeInterval < 1 {
            return ("-- MB/s", "-- MB/s")
        }

        let downloadSpeed = Double(bytesIn - lastBytesIn) / timeInterval
        let uploadSpeed = Double(bytesOut - lastBytesOut) / timeInterval

        lastBytesIn = bytesIn
        lastBytesOut = bytesOut
        lastTimestamp = now

        return (formatSpeed(speed: uploadSpeed), formatSpeed(speed: downloadSpeed))
    }

    private func formatSpeed(speed: Double) -> String {
        // Convert bytes/second directly to megabytes/second
        let megabytes = speed / 1024 / 1024
        
        // Guard against very small values, showing 0.0 MB/s instead of tiny numbers
        guard megabytes >= 0.01 else { return "0.0 MB/s" }

        return String(format: "%.1f MB/s", megabytes)
    }
}
