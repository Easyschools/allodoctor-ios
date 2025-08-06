//
//  UserLocationViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/10/2024.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Combine

class UserLocationViewController: BaseViewController<UserLocationViewModel> {
    
    // MARK: - Outlets
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var confirmationButton: CustomButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Properties
    private var centerMarkerView: UIImageView!
    private var lastUpdateTime: TimeInterval = 0
    private let updateThreshold: TimeInterval = 0.1
    private var currentMapCenter: CLLocationCoordinate2D?
    private var debounceTimer: Timer?
    private var placesClient: GMSPlacesClient!
    private var searchResults: [GMSAutocompletePrediction] = []
    private var resultsTableView: SearchResultsTableView!
    
    // MARK: - Constants
    private let egyptCenter = CLLocationCoordinate2D(latitude: 26.9, longitude: 29.5)
    private let defaultZoomLevel: Float = 15.0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupSearchView()
        setupResultsTableView()
        setupBindings()
        placesClient = GMSPlacesClient.shared()
        viewModel.startLocationUpdates()
        centerMapOnLocation(egyptCenter, zoom: defaultZoomLevel)
        
        // Setup center marker after map is configured
        DispatchQueue.main.async { [weak self] in
            self?.setupCenterMarker()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update center marker position when layout changes
        updateCenterMarkerPosition()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure marker is properly positioned when view appears
        updateCenterMarkerPosition()
    }
    
    deinit {
        debounceTimer?.invalidate()
        centerMarkerView?.removeFromSuperview()
        mapView?.removeFromSuperview()
        mapView?.delegate = nil
        mapView = nil
        placesClient = nil
        print("Deinitialized Google Maps and Places resources")
    }
    
    // MARK: - Setup Methods
    private func setupMapView() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        let egyptNE = CLLocationCoordinate2D(latitude: 31.8, longitude: 34.0)
        let egyptSW = CLLocationCoordinate2D(latitude: 22.0, longitude: 25.0)
        let egyptBounds = GMSCoordinateBounds(coordinate: egyptNE, coordinate: egyptSW)
        
        let camera = GMSCameraPosition.camera(
            withLatitude: egyptCenter.latitude,
            longitude: egyptCenter.longitude,
            zoom: defaultZoomLevel
        )
        mapView.camera = camera
        mapView.cameraTargetBounds = egyptBounds
    }
    
    private func setupCenterMarker() {
        // Remove existing marker if any
        centerMarkerView?.removeFromSuperview()
        
        // Create new marker
        centerMarkerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        centerMarkerView.image = UIImage.pinLocationFill 
        centerMarkerView.tintColor = .blueApp
        centerMarkerView.contentMode = .scaleAspectFit
        centerMarkerView.backgroundColor = .clear
        
        // Add to map view
        mapView.addSubview(centerMarkerView)
        updateCenterMarkerPosition()
        
        // Bring to front to ensure visibility
        mapView.bringSubviewToFront(centerMarkerView)
    }
    
    private func updateCenterMarkerPosition() {
        guard let centerMarkerView = centerMarkerView else { return }
        
        // Position marker at center of map view
        let centerX = mapView.bounds.width / 2
        let centerY = mapView.bounds.height / 2
        
        // Offset slightly upward to account for pin point being at bottom
        centerMarkerView.center = CGPoint(x: centerX, y: centerY - 20)
    }
    
    private func setupSearchView() {
        searchView.searchTextfield.delegate = self
        searchView.searchTextfield.addTarget(self,
                                          action: #selector(textFieldDidChange(_:)),
                                          for: .editingChanged)
        searchView.searchTextfield.placeholder = "Search locations in Egypt..."
    }
    
    private func setupResultsTableView() {
        resultsTableView = SearchResultsTableView(frame: .zero, style: .plain)
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        resultsTableView.backgroundColor = .white
        resultsTableView.layer.cornerRadius = 10
        resultsTableView.layer.masksToBounds = true
        resultsTableView.isHidden = true
        
        view.addSubview(resultsTableView)
        
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultsTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 8),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultsTableView.heightAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
    }
    
    private func setupBindings() {
        viewModel.$userLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let location = location else { return }
                if self?.isLocationInEgypt(location.coordinate) == true {
                    self?.centerMapOnLocation(location.coordinate)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @IBAction func confirmationButtonAction(_ sender: Any) {
        // Get the current center coordinate
        let centerCoordinate = mapView.projection.coordinate(for: mapView.center)
        
        guard isLocationInEgypt(centerCoordinate) else {
            showError("Please select a location within Egypt")
            return
        }
        
        // Update the current map center
        currentMapCenter = centerCoordinate
        viewModel.updateMarkerPosition(centerCoordinate)
        viewModel.handleNavigation(viewController: self)
    }
    
    @IBAction func dismissMapView(_ sender: Any) {
        viewModel.dismissMapView(viewController: self)
    }
    
    private func isLocationInEgypt(_ coordinate: CLLocationCoordinate2D) -> Bool {
        // Define Egypt's bounding box
        let minLat: Double = 22.0  // Southernmost point
        let maxLat: Double = 31.7  // Northernmost point
        let minLon: Double = 24.7  // Westernmost point
        let maxLon: Double = 36.0  // Easternmost point

        // Check if the point is within the bounding box
        let isWithinBounds = coordinate.latitude >= minLat &&
                             coordinate.latitude <= maxLat &&
                             coordinate.longitude >= minLon &&
                             coordinate.longitude <= maxLon

        return isWithinBounds
    }
    
    private func updateLocation() {
        let currentTime = CACurrentMediaTime()
        guard currentTime - lastUpdateTime >= updateThreshold else { return }
        
        let centerCoordinate = mapView.projection.coordinate(for: mapView.center)
        currentMapCenter = centerCoordinate
        viewModel.updateMarkerPosition(centerCoordinate)
        lastUpdateTime = currentTime
    }
    
    private func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D, zoom: Float? = nil) {
        let camera = GMSCameraPosition.camera(
            withLatitude: coordinate.latitude,
            longitude: coordinate.longitude,
            zoom: zoom ?? mapView.camera.zoom
        )
        mapView.animate(to: camera)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        debounceTimer?.invalidate()
        
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let self = self, let query = textField.text, !query.isEmpty else {
                self?.searchResults = []
                self?.resultsTableView.isHidden = true
                return
            }
            
            let filter = GMSAutocompleteFilter()
            filter.type = .region
            filter.countries = ["EG"]
            
            self.placesClient.findAutocompletePredictions(
                fromQuery: query,
                filter: filter,
                sessionToken: nil
            ) { [weak self] (results, error) in
                guard let self = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.showError(error.localizedDescription)
                    }
                    return
                }
                
                self.searchResults = results ?? []
                
                DispatchQueue.main.async {
                    self.resultsTableView.isHidden = self.searchResults.isEmpty
                    self.resultsTableView.reloadData()
                }
            }
        }
    }
    
    private func fetchPlaceDetails(for placeID: String) {
        let fields: GMSPlaceField = [.name, .coordinate]
        
        placesClient.fetchPlace(
            fromPlaceID: placeID,
            placeFields: fields,
            sessionToken: nil
        ) { [weak self] (place, error) in
            guard let self = self, let place = place else {
                if let error = error {
                    DispatchQueue.main.async {
                        self?.showError(error.localizedDescription)
                    }
                }
                return
            }
            
            guard self.isLocationInEgypt(place.coordinate) else {
                DispatchQueue.main.async {
                    self.showError("Selected location is outside Egypt")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.centerMapOnLocation(place.coordinate)
                self.resultsTableView.isHidden = true
                self.searchView.searchTextfield.resignFirstResponder()
                self.searchView.searchTextfield.text = place.name
            }
        }
    }
}

// MARK: - GMSMapViewDelegate
extension UserLocationViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // Update marker position when map moves
        updateCenterMarkerPosition()
        updateLocationDebounced()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // Final update when map stops moving
        updateCenterMarkerPosition()
        updateLocationDebounced()
    }
    
    private func updateLocationDebounced() {
        debounceTimer?.invalidate()
        
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateLocation()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UserLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        let prediction = searchResults[indexPath.row]
        cell.configure(with: prediction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prediction = searchResults[indexPath.row]
        fetchPlaceDetails(for: prediction.placeID)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension UserLocationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !searchResults.isEmpty {
            resultsTableView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.resultsTableView.isHidden = true
        }
    }
}

// MARK: - SearchResultsTableView
class SearchResultsTableView: UITableView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let superview = self.superview else { return false }
        let convertedPoint = self.convert(point, to: superview)
        return self.frame.contains(convertedPoint)
    }
}

// MARK: - SearchResultCell
class SearchResultCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with prediction: GMSAutocompletePrediction) {
        titleLabel.text = prediction.attributedPrimaryText.string
        subtitleLabel.text = prediction.attributedSecondaryText?.string
    }
}
