//
//  PharmacyGlobalSearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/11/2024.
//

import Foundation
import Combine

class PharmacyGlobalSearchViewModel: ObservableObject {
    // MARK: - InitViewModel + Properties
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var searchText: String = "" {
        didSet {
            // Debounced search will be handled by the subscription
        }
    }
    @Published var isLoading: Bool = false
    private var apiClient = APIClient()
    @Published var pharmacies: [Pharmacy]?
    
    // Search task to handle cancellation
    private var searchTask: AnyCancellable?
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        setupSearchSubscription()
    }
    
    deinit {
        cancellables.removeAll()
        searchTask?.cancel()
    }
}

// MARK: - Search Setup and API Calls
extension PharmacyGlobalSearchViewModel {
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.handleSearchTextChange(searchText)
            }
            .store(in: &cancellables)
    }
    
    private func handleSearchTextChange(_ searchText: String) {
        // Cancel previous search task
        searchTask?.cancel()
        
        print("Search Text Updated: \(searchText)")
        
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // Clear results when search is empty
            self.pharmacies = nil
            self.isLoading = false
            return
        }
        
        performSearch(searchText: searchText)
    }
    
    private func performSearch(searchText: String) {
        isLoading = true
        getPharmacies(lat: "", long: "", search: searchText)
    }

    private func getPharmacies(lat: String, long: String, search: String) {
        let trimmedSearch = search.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSearch.isEmpty else {
            isLoading = false
            return
        }
        
        let encodedText = trimmedSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let router = APIRouter.fetchPharmacies(isPaginate: 2, lat: lat, long: long, search: encodedText)
        
        searchTask = apiClient.fetchData(from: router.url, as: PharmaciesResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching pharmacies: \(error)")
                    self?.errorMessage = "Failed to fetch pharmacies: \(error.localizedDescription)"
                    self?.pharmacies = nil
                }
            }, receiveValue: { [weak self] pharmacyResponse in
                self?.pharmacies = pharmacyResponse.data
                self?.errorMessage = nil
                print("Pharmacies found: \(pharmacyResponse.data.count)")
            })
    }
}

// MARK: - Navigation
extension PharmacyGlobalSearchViewModel {
    func navigationToCategory(pharmacyId: Int) {
        coordinator?.showPharmacyCategory(pharmacyId: pharmacyId)
    }
    
    func navigationBack() {
        coordinator?.navigateBack()
    }
    
//    func navigateToSeeMorePharmacies() {
//        // Navigate to see more pharmacies screen with current search text
//        coordinator?.showAllPharmacies(searchText: searchText)
//    }
}
