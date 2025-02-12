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
    private let screenType: ScreenUserLocationType
    var coordinator: HomeCoordinatorContact?
    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    
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
        markerPosition = position
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
    func handleNavigation() {
        switch screenType {
        case .pharmacyHome:
            dismissToPharmacyModel()
        case .userAddress:
            navToUserAddress()
        case .uploadPresription:
            navToUserAddress()
        }
    }
    
    private func dismissToPharmacyModel() {
        guard let position = markerPosition else { return }
        let lat = String(format: "%.6f", position.latitude)
        let long = String(format: "%.6f", position.longitude)
        UserDefaultsManager.sharedInstance.setCoordinates(lat:lat,long:long)
        dismissToPharmacyModel(lat: lat, long: long)
    }
    
    private func navToUserAddress() {
        guard let position = markerPosition else { return }
        let lat = String(format: "%.6f", position.latitude)
        let long = String(format: "%.6f", position.longitude)
        coordinator?.showCreateAddress(lat: lat, long: long)
    }
    
    func dismissMapView(viewController: UIViewController) {
        coordinator?.dismissPresnetiontabBarNav(viewController)
    }
}
