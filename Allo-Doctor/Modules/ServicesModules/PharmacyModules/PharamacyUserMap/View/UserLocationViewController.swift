//
//  UserLocationViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/10/2024.
//
import UIKit
import GoogleMaps
import Combine

class UserLocationViewController: BaseViewController<UserLocationViewModel> {
    
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var confirmationButton: CustomButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    private var centerMarkerView: UIImageView!
    private var lastUpdateTime: TimeInterval = 0
    private let updateThreshold: TimeInterval = 0.1 // 100ms threshold
    private var currentMapCenter: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupCenterMarker()
        setupBindings()
        viewModel.startLocationUpdates()

    }
    deinit {
         GoogleMapManager.shared.cleanupMapView(mapView)
     }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Clean up map resources when view disappears
           if isMovingFromParent {
               GoogleMapManager.shared.cleanupMapView(mapView)
           }
       }
    private func setupMapView() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
  
    private func setupCenterMarker() {
        centerMarkerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        centerMarkerView.image = .pinLocationFill
        centerMarkerView.center = CGPoint(x: mapView.frame.width / 2, y: mapView.frame.height / 2)
        centerMarkerView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        mapView.addSubview(centerMarkerView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update center marker position after layout changes
        centerMarkerView.center = CGPoint(x: mapView.frame.width / 2, y: mapView.frame.height / 2)
    }
    
    @IBAction func confirmationButtonAction(_ sender: Any) {
        // Use latest marker position
        viewModel.handleNavigation()
    }
    
    @IBAction func dismissMapView(_ sender: Any) {
        viewModel.dismissMapView(viewController: self)
    }
    private func updateLocation() {
        let currentTime = CACurrentMediaTime()
        guard currentTime - lastUpdateTime >= updateThreshold else { return }
        
        let centerCoordinate = mapView.projection.coordinate(for: mapView.center)
        currentMapCenter = centerCoordinate
        viewModel.updateMarkerPosition(centerCoordinate)
        lastUpdateTime = currentTime
    }
    
    private func setupBindings() {
        viewModel.$userLocation
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.centerMapOnLocation(location.coordinate)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { error in
                print("Error: \(error)")
            }
            .store(in: &cancellables)
    }
    
    private func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
        mapView.animate(to: camera)
    }
}

// MARK: - GMSMapViewDelegate
extension UserLocationViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        updateLocation() // Keeps track of the updated location
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        updateLocation() // Called after user finishes dragging
    }
}
