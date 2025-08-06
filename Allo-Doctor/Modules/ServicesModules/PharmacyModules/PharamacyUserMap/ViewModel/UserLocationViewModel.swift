//
//  UserLocationViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/10/2024.
//
 
import CoreLocation
import GoogleMaps
import UIKit

enum ScreenUserLocationType {
    case pharmacyHome
    case userAddress
    case uploadPresription
}

class UserLocationViewModel: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var markerPosition: CLLocationCoordinate2D?
    @Published var errorMessage: String?
    @Published var selectedAreaName: String?
    private let screenType: ScreenUserLocationType
    var coordinator: HomeCoordinatorContact?
    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    private let geocoder = CLGeocoder()
    
    init(coordinator: HomeCoordinatorContact? = nil,
         apiClient: APIClient = APIClient(),
         screenType: ScreenUserLocationType) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.screenType = screenType
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocationUpdates() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func updateMarkerPosition(_ position: CLLocationCoordinate2D) {
        print("🔍 Updating marker position to: \(position.latitude), \(position.longitude)")
        markerPosition = position
        // Save the selected location to UserDefaults whenever marker position updates
        saveSelectedLocationToUserDefaults(position)
        // Get area name from coordinates (pin position)
        getAreaNameFromCoordinates(position)
    }
    
    // MARK: - UserDefaults Management
    private func saveSelectedLocationToUserDefaults(_ position: CLLocationCoordinate2D) {
        let lat = String(format: "%.6f", position.latitude)
        let long = String(format: "%.6f", position.longitude)
        UserDefaultsManager.sharedInstance.setCoordinates(lat: lat, long: long)
    }
    
    // MARK: - Reverse Geocoding
    private func getAreaNameFromCoordinates(_ coordinate: CLLocationCoordinate2D) {
        print("🌍 Getting area name for coordinates: \(coordinate.latitude), \(coordinate.longitude)")
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Reverse geocoding failed: \(error.localizedDescription)")
                    self?.selectedAreaName = nil
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    print("❌ No placemark found")
                    self?.selectedAreaName = nil
                    return
                }
                
                // Try to get area name in order of preference
                let areaName = self?.extractAreaName(from: placemark)
                print("📍 Area name detected: \(areaName ?? "nil")")
                self?.selectedAreaName = areaName
                
                // Save area name to UserDefaults
                if let areaName = areaName {
                    self?.saveAreaNameToUserDefaults(areaName)
                }
            }
        }
    }
    
    private func extractAreaName(from placemark: CLPlacemark) -> String? {
        // Priority order for area name extraction
        // 1. subLocality (like "New Cairo", "Maadi")
        if let subLocality = placemark.subLocality, !subLocality.isEmpty {
            return subLocality
        }
        
        // 2. locality (city name)
        if let locality = placemark.locality, !locality.isEmpty {
            return locality
        }
        
        // 3. subAdministrativeArea (governorate subdivision)
        if let subAdministrativeArea = placemark.subAdministrativeArea, !subAdministrativeArea.isEmpty {
            return subAdministrativeArea
        }
        
        // 4. administrativeArea (governorate like "Cairo", "Giza")
        if let administrativeArea = placemark.administrativeArea, !administrativeArea.isEmpty {
            return administrativeArea
        }
        
        // 5. name (general place name)
        if let name = placemark.name, !name.isEmpty {
            return name
        }
        
        return nil
    }
    
    private func saveAreaNameToUserDefaults(_ areaName: String) {
        UserDefaults.standard.set(areaName, forKey: "selectedAreaName")
        print("💾 Area name saved to UserDefaults: \(areaName)")
    }
    
    func getCurrentSelectedLocation() -> (latitude: String, longitude: String, areaName: String?)? {
        guard let position = markerPosition else { return nil }
        let lat = String(format: "%.6f", position.latitude)
        let long = String(format: "%.6f", position.longitude)
        return (latitude: lat, longitude: long, areaName: selectedAreaName)
    }
    
    func getSavedAreaName() -> String? {
        return UserDefaults.standard.string(forKey: "selectedAreaName")
    }
    
    // Call this method to detect area name for current pin position
    func detectAreaForCurrentPin() {
        guard let position = markerPosition else { return }
        saveSelectedLocationToUserDefaults(position)
        getAreaNameFromCoordinates(position)
    }
    
    // Call this when map center changes (if pin follows map center)
    func updateMapCenter(_ center: CLLocationCoordinate2D) {
        markerPosition = center
        saveSelectedLocationToUserDefaults(center)
        getAreaNameFromCoordinates(center)
    }
    
    
    func dismissToPharmacyModel(lat: String, long: String) {
        coordinator?.dissToPharmacyHome(lat: lat, long: long)
    }
}

// MARK: - CLLocationManagerDelegate
extension UserLocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.userLocation = location
            if self.markerPosition == nil {
                self.markerPosition = location.coordinate
                // Get area name for initial pin position
                self.saveSelectedLocationToUserDefaults(location.coordinate)
                self.getAreaNameFromCoordinates(location.coordinate)
            }
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Navigation Handling
extension UserLocationViewModel {
    func handleNavigation(viewController: UIViewController?) {
        // Ensure the current selected location is saved before navigation
        if let position = markerPosition {
            saveSelectedLocationToUserDefaults(position)
        }
        
        switch screenType {
        case .pharmacyHome:
            dismissToPharmacyModel()
        case .userAddress:
            navToUserAddress(UIViewController: viewController!, orderScreenType: .orderScreen)
        case .uploadPresription:
            navToUserAddress(UIViewController: viewController!, orderScreenType: .uploadPrescription)
        }
    }
    
    private func dismissToPharmacyModel() {
        guard let position = markerPosition else { return }
        let lat = String(format: "%.6f", position.latitude)
        let long = String(format: "%.6f", position.longitude)
        UserDefaultsManager.sharedInstance.setCoordinates(lat:lat,long:long)
        UserDefaultsManager.sharedInstance.setArea(areaName: selectedAreaName ?? "")
        coordinator?.dissToPharmacyHome(lat: lat, long: long)
    }
    
    private func navToUserAddress(UIViewController: UIViewController, orderScreenType: OrderScreenType) {
        guard let position = markerPosition else { return }
        let lat = String(format: "%.6f", position.latitude)
        let long = String(format: "%.6f", position.longitude)
        coordinator?.showCreateAddress(lat: lat, long: long, UIViewController: UIViewController, orderScreenType: orderScreenType)
    }
    
    func dismissMapView(viewController: UIViewController) {
        // Save current location before dismissing
        if let position = markerPosition {
            saveSelectedLocationToUserDefaults(position)
        }
        
        if screenType == .userAddress {
            coordinator?.navigationBack()
        } else {
            coordinator?.dismissPresnetiontabBarNav(viewController)
        }
    }
}
