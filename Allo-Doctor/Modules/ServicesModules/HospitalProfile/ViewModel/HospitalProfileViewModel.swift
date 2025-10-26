//
//  HospitalProfileViewModel.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit
import Combine

class HospitalProfileViewModel {
    // MARK: - Published Properties
    @Published var hospitalProfile: HospitalProfile?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isFavorite: Bool = false

    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    private var hospitalId: Int

    // MARK: - Initialization
    init(
        coordinator: HomeCoordinatorContact? = nil,
        apiClient: APIClient = APIClient(),
        hospitalId: Int
    ) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.hospitalId = hospitalId
    }

    // MARK: - Fetch Hospital Profile
    func fetchHospitalProfile() {
        isLoading = true
        errorMessage = nil

        let router = APIRouter.fetchHospitalProfile(hospitalId: hospitalId)

        apiClient.fetchData(from: router.url, as: HospitalProfileResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching hospital profile: \(error)")
                    self?.errorMessage = "Failed to fetch hospital profile: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.hospitalProfile = response.data
                print("Fetched hospital profile: \(response.data.name)")
                self?.checkFavoriteStatus()
            })
            .store(in: &cancellables)
    }

    // MARK: - Favorite Management
    func toggleFavorite() {
        if isFavorite {
            removeFavorite()
        } else {
            addFavorite()
        }
    }

    private func addFavorite() {
        // Implement add to favorites API call
        let params = [
            "favoritable_id": hospitalId,
            "favoritable_entity": "hospital"
        ] as [String : Any]

        // For now, just toggle locally
        isFavorite = true
        print("Added hospital \(hospitalId) to favorites")
    }

    private func removeFavorite() {
        // Implement remove from favorites API call
        let router = APIRouter.delteFav(entity: "hospital", id: hospitalId)

        // For now, just toggle locally
        isFavorite = false
        print("Removed hospital \(hospitalId) from favorites")
    }

    private func checkFavoriteStatus() {
        let router = APIRouter.isFavourite(entity: "hospital", id: hospitalId)

        apiClient.fetchData(from: router.url, as: FavouriteResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error checking favorite status: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.isFavorite = response.data?.isEmpty == false
            })
            .store(in: &cancellables)
    }

    // MARK: - Navigation
    func navigateToSpecialty(specialtyId: Int) {
        coordinator?.showHospitalSpecialty(hospitalId: hospitalId, specialtyId: specialtyId)
    }

    func showReviews() {
        // Navigate to reviews screen (if exists)
        print("Show all reviews for hospital \(hospitalId)")
    }

    func showInsurance() {
        // Navigate to insurance details screen (if exists)
        print("Show insurance details for hospital \(hospitalId)")
    }

    func showLocation() {
        // Navigate to map view with hospital location
        if let lat = hospitalProfile?.latitude,
           let long = hospitalProfile?.longitude,
           let latitude = Double(lat),
           let longitude = Double(long) {
            print("Show location: \(latitude), \(longitude)")
            // coordinator?.showMapLocation(latitude: latitude, longitude: longitude)
        }
    }

    func callHospital() {
        if let phone = hospitalProfile?.phone, let url = URL(string: "tel://\(phone)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }

    // MARK: - Helpers
    func getDisplayName() -> String {
        guard let profile = hospitalProfile else { return "" }

        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            return profile.nameAr ?? profile.name
        } else {
            return profile.nameEn ?? profile.name
        }
    }

    func getDisplayDescription() -> String? {
        guard let profile = hospitalProfile else { return nil }

        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            return profile.descriptionAr ?? profile.description
        } else {
            return profile.descriptionEn ?? profile.description
        }
    }

    func getSpecialtyDisplayName(for specialty: HospitalSpecialty) -> String {
        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            return specialty.nameAr ?? specialty.name
        } else {
            return specialty.nameEn ?? specialty.name
        }
    }

    func formatRating(_ rating: Double?) -> String {
        guard let rating = rating else {
            return NSLocalizedString("No rating", comment: "")
        }
        return String(format: "%.1f", rating)
    }

    func getSpecialtiesCount() -> Int {
        return hospitalProfile?.specialties.count ?? 0
    }

    func getReviewsCount() -> Int {
        return hospitalProfile?.reviewsCount ?? 0
    }
}
