//
//  ReachabilityManger.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//
import Reachability
import Foundation

extension Notification.Name {
    static let slowConnection = Notification.Name("slowConnection")
    static let goodConnection = Notification.Name("goodConnection")
    static let noConnection = Notification.Name("noConnection")
}

class ReachabilityManager {
    static let shared = ReachabilityManager()
    private var reachability: Reachability!

    private init() {
        reachability = try? Reachability()

        // Add observer for reachability changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged),
            name: .reachabilityChanged,
            object: reachability
        )

        // Start monitoring
        try? reachability.startNotifier()
    }

    // Reachability changed handler
    @objc private func reachabilityChanged(notification: Notification) {
        if let reachability = notification.object as? Reachability {
            switch reachability.connection {
            case .wifi, .cellular:
                if isSlowConnection() {
                    print("Slow internet connection")
                    NotificationCenter.default.post(name: .slowConnection, object: nil)
                } else {
                    print("Connected with good connection")
                    NotificationCenter.default.post(name: .goodConnection, object: nil)
                }
                
            case .unavailable:
                print("No Internet Connection")
                NotificationCenter.default.post(name: .noConnection, object: nil)
            }
        }
    }

    // Check current reachability status
    func isReachable() -> Bool {
        return reachability.connection != .unavailable
    }

    // Dummy slow connection check (replace with actual logic)
    func isSlowConnection() -> Bool {
        // Here you can implement network response time checks (optional)
        return false // Placeholder: return true if you want to simulate slow connection
    }
}
