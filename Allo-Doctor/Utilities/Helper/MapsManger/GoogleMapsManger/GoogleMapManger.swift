//
//  GoogleMapManger.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/11/2024.
//

import Foundation
import GoogleMaps
class GoogleMapManager {
    static let shared = GoogleMapManager()
    private let initializationQueue = DispatchQueue(label: "com.app.maps.initialization", qos: .userInteractive)
    
    private init() {}
    
    func initializeGoogleMaps() {
        // Use a dispatch group to ensure synchronous initialization
        let group = DispatchGroup()
        group.enter()
        
        initializationQueue.async {
            autoreleasepool {
//                // Initialize Google Maps
//                GMSServices.provideAPIKey("AIzaSyDJkVY_BdzPGHKPRV1zvVNoqiw2sbOszXg")
                group.leave()
            }
        }
        
        // Wait with a reasonable timeout
        _ = group.wait(timeout: .now() + 2.0)
    }
    
    func cleanupMapView(_ mapView: GMSMapView?) {
        guard let mapView = mapView else { return }
        
        // Ensure cleanup happens on main thread
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                self.cleanupMapView(mapView)
            }
            return
        }
        
        // Proper cleanup sequence
        mapView.delegate = nil
        mapView.clear()
    }
}
