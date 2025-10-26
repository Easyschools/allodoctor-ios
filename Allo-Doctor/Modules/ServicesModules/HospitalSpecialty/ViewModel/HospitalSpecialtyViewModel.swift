//
//  HospitalSpecialtyViewModel.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit
import Combine

class HospitalSpecialtyViewModel {
    // MARK: - Published Properties
    @Published var specialtyDetail: HospitalSpecialtyDetail?
    @Published var doctors: [SpecialtyDoctor] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    private var hospitalId: Int
    private var specialtyId: Int

    // MARK: - Initialization
    init(
        coordinator: HomeCoordinatorContact? = nil,
        apiClient: APIClient = APIClient(),
        hospitalId: Int,
        specialtyId: Int
    ) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.hospitalId = hospitalId
        self.specialtyId = specialtyId
    }

    // MARK: - Fetch Specialty Details
    func fetchSpecialtyDetail() {
        isLoading = true
        errorMessage = nil

        let router = APIRouter.fetchHospitalSpecialtyDetail(
            hospitalId: hospitalId,
            specialtyId: specialtyId
        )

        apiClient.fetchData(from: router.url, as: HospitalSpecialtyDetailResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching specialty detail: \(error)")
                    self?.errorMessage = "Failed to fetch specialty details: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.specialtyDetail = response.data
                self?.doctors = response.data.doctors
                print("Fetched \(response.data.doctors.count) doctors for specialty")
            })
            .store(in: &cancellables)
    }

    // MARK: - Navigation
    func navigateToDoctorProfile(doctorId: Int) {
        // Navigate to doctor profile
        coordinator?.showDoctorProfile(doctorID: String(doctorId), doctorPlace: .outpatientClinics)
    }

    // MARK: - Helpers
    func getSpecialtyName() -> String {
        guard let specialty = specialtyDetail?.specialty else { return "" }

        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            return specialty.nameAr ?? specialty.name
        } else {
            return specialty.nameEn ?? specialty.name
        }
    }

    func getSpecialtyDescription() -> String? {
        guard let specialty = specialtyDetail?.specialty else { return nil }

        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            return specialty.descriptionAr ?? specialty.description
        } else {
            return specialty.descriptionEn ?? specialty.description
        }
    }

    func getDoctorDisplayName(for doctor: SpecialtyDoctor) -> String {
        return doctor.name
    }

    func getDoctorTitle(for doctor: SpecialtyDoctor) -> String? {
        if LocalizationManager.shared.getCurrentLanguage() == "ar" {
            return doctor.titleAr ?? doctor.title
        } else {
            return doctor.titleEn ?? doctor.title
        }
    }

    func formatRating(_ rating: Double?) -> String {
        guard let rating = rating else {
            return NSLocalizedString("No rating", comment: "")
        }
        return String(format: "%.1f", rating)
    }

    func formatPrice(_ price: String?, discounted: String?) -> String {
        if let discounted = discounted, !discounted.isEmpty, discounted != "0" {
            return discounted + " " + NSLocalizedString("EGP", comment: "")
        } else if let price = price {
            return price + " " + NSLocalizedString("EGP", comment: "")
        }
        return NSLocalizedString("Contact for price", comment: "")
    }

    func getDoctorsCount() -> Int {
        return doctors.count
    }
}
