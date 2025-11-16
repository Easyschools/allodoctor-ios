//
//  HospitalSpecialtiesViewModel.swift
//  Allo-Doctor
//
//  Created by Assistant on 15/11/2025.
//

import Foundation
import Combine

class HospitalSpecialtiesViewModel {
    // MARK: - Published Properties
    @Published var specialties: [Specialty] = []
    @Published var filteredSpecialties: [Specialty] = []
    @Published var searchText: String = ""

    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    private var hospitalId: Int
    private var hospitalName: String

    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, hospitalId: Int, hospitalName: String, specialties: [Specialty]) {
        self.coordinator = coordinator
        self.hospitalId = hospitalId
        self.hospitalName = hospitalName
        self.specialties = specialties
        self.filteredSpecialties = specialties

        setupSearchSubscription()
    }

    // MARK: - Search
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterSpecialties(with: searchText)
            }
            .store(in: &cancellables)
    }

    private func filterSpecialties(with searchText: String) {
        if searchText.isEmpty {
            filteredSpecialties = specialties
        } else {
            let language = UserDefaultsManager.sharedInstance.getLanguage()
            filteredSpecialties = specialties.filter { specialty in
                let name = language == .ar ? (specialty.nameAr ?? specialty.name ?? "") : (specialty.nameEn ?? specialty.name ?? "")
                return name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // MARK: - Navigation Methods
    func navigateToSpecialty(specialty: Specialty) {
        coordinator?.showDoctorsForHospital(hospitalId: hospitalId, specialtyId: specialty.id)
    }

    func navigateBack() {
        coordinator?.navigateBack()
    }
}
