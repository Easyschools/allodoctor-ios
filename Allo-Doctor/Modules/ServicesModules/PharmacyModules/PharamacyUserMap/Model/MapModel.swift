//
//  MapModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/10/2024.
//

import Foundation
import CoreLocation
import GoogleMaps
// MARK: - Models
struct LocationDetails {
    let coordinate: CLLocationCoordinate2D
    let address: String?
    let title: String?
}

enum MapError: Error {
    case locationPermissionDenied
    case geocodingFailed
    case searchFailed
    case invalidLocation
}

enum LocationPermission {
    case authorized
    case denied
    case notDetermined
}

enum MapViewState {
    case idle
    case loading
    case error(MapError)
}
