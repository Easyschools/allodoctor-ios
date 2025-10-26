//
//  HospitalSelectionViewModel.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit
import Combine

class HospitalSelectionViewModel {
    // MARK: - Published Properties
    @Published var hospitals: [UnifiedHospital] = []
    @Published var filteredHospitals: [UnifiedHospital] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var filterOptions: HospitalFilterOptions
    @Published var districts: [DistrictFilterOption] = []
    @Published var specialties: [SpecialtyFilterOption] = []

    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    private var serviceType: HospitalServiceType?

    // MARK: - Initialization
    init(
        coordinator: HomeCoordinatorContact? = nil,
        apiClient: APIClient = APIClient(),
        serviceType: HospitalServiceType? = nil
    ) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.serviceType = serviceType
        self.filterOptions = HospitalFilterOptions(serviceType: serviceType)

        setupSearchSubscription()
        setupFilterSubscription()
    }

    // MARK: - Search Setup
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterOptions.searchQuery = searchText
                self?.fetchHospitals()
            }
            .store(in: &cancellables)
    }

    // MARK: - Filter Setup
    private func setupFilterSubscription() {
        $filterOptions
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFiltersLocally()
            }
            .store(in: &cancellables)
    }

    // MARK: - Fetch Hospitals
    func fetchHospitals() {
        isLoading = true
        errorMessage = nil

        // Build query parameters
        let params = filterOptions.toQueryParameters()
        let router = APIRouter.fetchAllHospitals(
            search: params["search"] ?? "",
            districtIds: params["district_ids"] ?? "",
            specialtyIds: params["specialty_ids"] ?? "",
            serviceType: params["service_type"] ?? "",
            sortBy: params["sort_by"] ?? "name",
            minRating: params["min_rating"] ?? "",
            maxDistance: params["max_distance"] ?? ""
        )

        apiClient.fetchData(from: router.url, as: HospitalListResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching hospitals: \(error)")
                    self?.errorMessage = "Failed to fetch hospitals: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.hospitals = response.data
                self?.applyFiltersLocally()
                print("Fetched \(response.data.count) hospitals")
            })
            .store(in: &cancellables)
    }

    // MARK: - Fetch Filter Options
    func fetchDistricts() {
        let router = APIRouter.fetchDistricts(isPaginate: 0)

        apiClient.fetchData(from: router.url, as: DistrictListResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching districts: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.districts = response.data.map { $0.toFilterOption() }
                print("Fetched \(response.data.count) districts")
            })
            .store(in: &cancellables)
    }

    func fetchSpecialties() {
        let router = APIRouter.fetchSpecialtiesForFilter(isPaginate: 0)

        apiClient.fetchData(from: router.url, as: SpecialtyListResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching specialties: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.specialties = response.data.map { $0.toFilterOption() }
                print("Fetched \(response.data.count) specialties")
            })
            .store(in: &cancellables)
    }

    // MARK: - Local Filtering & Sorting
    private func applyFiltersLocally() {
        var filtered = hospitals

        // Apply rating filter
        if let minRating = filterOptions.minRating {
            filtered = filtered.filter { ($0.avgRating ?? 0) >= minRating }
        }

        // Apply distance filter
        if let maxDistance = filterOptions.maxDistance {
            filtered = filtered.filter {
                guard let distance = $0.distance else { return true }
                return distance <= maxDistance
            }
        }

        // Apply sorting
        filtered = sortHospitals(filtered, by: filterOptions.sortBy)

        filteredHospitals = filtered
    }

    private func sortHospitals(_ hospitals: [UnifiedHospital], by sortOption: HospitalSortOption) -> [UnifiedHospital] {
        switch sortOption {
        case .name:
            return hospitals.sorted { ($0.name) < ($1.name) }
        case .rating:
            return hospitals.sorted { ($0.avgRating ?? 0) > ($1.avgRating ?? 0) }
        case .distance:
            return hospitals.sorted { ($0.distance ?? Double.infinity) < ($1.distance ?? Double.infinity) }
        case .reviewsCount:
            return hospitals.sorted { ($0.reviewsCount ?? 0) > ($1.reviewsCount ?? 0) }
        }
    }

    // MARK: - Filter Management
    func updateFilter(_ newFilter: HospitalFilterOptions) {
        self.filterOptions = newFilter
        fetchHospitals()
    }

    func clearFilters() {
        filterOptions = HospitalFilterOptions(serviceType: serviceType, sortBy: .name)
        searchText = ""
        fetchHospitals()
    }

    func updateSort(_ sortOption: HospitalSortOption) {
        filterOptions.sortBy = sortOption
        applyFiltersLocally()
    }

    // MARK: - Navigation
    func navigateToHospitalProfile(hospitalId: Int) {
        coordinator?.showHospitalProfile(hospitalId: hospitalId)
    }

    func presentFilterView(from viewController: UIViewController) {
        let filterVC = HospitalFilterViewController(
            currentFilters: filterOptions,
            districts: districts,
            specialties: specialties
        )

        filterVC.onFiltersApplied = { [weak self] newFilters in
            self?.updateFilter(newFilters)
        }

        let sheetController = FWIPNSheetViewController(controller: filterVC, sizes: [.fixed(620)])
        sheetController.cornerRadius = 16

        viewController.present(sheetController, animated: true, completion: nil)
    }

    func presentSortView(from viewController: UIViewController) {
        let sortVC = HospitalSortViewController(currentSort: filterOptions.sortBy)

        sortVC.onSortSelected = { [weak self] sortOption in
            self?.updateSort(sortOption)
        }

        let sheetController = FWIPNSheetViewController(controller: sortVC, sizes: [.fixed(300)])
        sheetController.cornerRadius = 16

        viewController.present(sheetController, animated: true, completion: nil)
    }

    // MARK: - Helpers
    func getDisplayName(for hospital: UnifiedHospital) -> String {
        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            return hospital.nameAr ?? hospital.name
        } else {
            return hospital.nameEn ?? hospital.name
        }
    }

    func getDisplayDescription(for hospital: UnifiedHospital) -> String? {
        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            return hospital.descriptionAr ?? hospital.description
        } else {
            return hospital.descriptionEn ?? hospital.description
        }
    }

    func formatDistance(_ distance: Double?) -> String {
        guard let distance = distance else {
            return ""
        }

        if distance < 1 {
            return String(format: "%.0f m", distance * 1000)
        } else {
            return String(format: "%.1f km", distance)
        }
    }

    func formatRating(_ rating: Double?) -> String {
        guard let rating = rating else {
            return NSLocalizedString("No rating", comment: "")
        }
        return String(format: "%.1f", rating)
    }
}
