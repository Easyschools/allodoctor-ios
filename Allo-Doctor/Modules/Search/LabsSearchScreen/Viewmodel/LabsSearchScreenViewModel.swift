//
//  LabsSearchScreenViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import Foundation

class LabsSearchScreenViewModel {
    @Published var labs: [LabInfo]?
    @Published var scans: [LabAndScans]?
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    
    // Search-related properties
    @Published var searchQuery = ""
    private let searchSubject = PassthroughSubject<String, Never>()
    private let debounceInterval: TimeInterval = 0.5
    
    var coordinator: HomeCoordinatorContact?
    var screenType: String?
    var url: URL?
    private var apiClient: APIClient?
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), screenType: String) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.screenType = screenType
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        // Set up the debounced search pipeline
        searchSubject
            .debounce(for: .seconds(debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(_ searchText: String) {
        let baseURL = "https://Backend.allo-doctor.com/api/admin/lab/all"
        var urlComponents = URLComponents(string: baseURL)
        
        // Create query parameters
        var queryItems = [
            URLQueryItem(name: "is_paginate", value: "15"),
            URLQueryItem(name: "service_id", value: screenType ?? "17"),
            URLQueryItem(name: "web", value: "1")
        ]
        
        // Add search parameter if text is not empty
        if !searchText.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: searchText))
        }
        
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return }
        
        apiClient?.fetchData(from: url, as: LabResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Labs: \(error.localizedDescription)"
                    print(error)
                }
            }, receiveValue: { [weak self] labsResponse in
                self?.labs = labsResponse.data
            })
            .store(in: &cancellables)
    }
    
    // Function to trigger search
    func search(query: String) {
        searchSubject.send(query)
    }
    
    // Existing functions
    func fetchLabsAndScans(search: String, medicalInsuranceId: Int?) {
        var urlComponents = URLComponents(string: "https://Backend.allo-doctor.com/api/admin/lab/all")
        
        var queryItems = [
            URLQueryItem(name: "is_paginate", value: "15"),
            URLQueryItem(name: "service_id", value: screenType ?? "17"),
            URLQueryItem(name: "web", value: "1")
        ]
        
        if let insuranceId = medicalInsuranceId {
            queryItems.append(URLQueryItem(name: "medical_insurance[]", value: String(insuranceId)))
        }
        
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }
        
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return }
        
        apiClient?.fetchData(from: url, as: LabResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Labs: \(error.localizedDescription)"
                    print(error)
                }
            }, receiveValue: { [weak self] labsResponse in
                self?.labs = labsResponse.data
            })
            .store(in: &cancellables)
    }
    
    func navToLabsAnsScanProfile(url: String, id: Int) {
        coordinator?.showLabsAndScanProfile(url: url, type: screenType ?? "17", id: id)
    }
    
    func getAllAreaOfResidence() {
        let router = APIRouter.fetchCities
        apiClient?.fetchData(from: router.url, as: CityDataResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Cities: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] citiesResponse in
                self?.cities = citiesResponse.data ?? []
            })
            .store(in: &cancellables)
    }
}
