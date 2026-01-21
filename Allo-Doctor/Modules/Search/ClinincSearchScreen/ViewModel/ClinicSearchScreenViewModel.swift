//
//  ClinicSearchScreenViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import Foundation
import Combine

enum ClinicSearchDisplayMode {
    case clinics
    case hospitalSpecialties(hospitalId: Int, specialties: [Specialty])
}

class ClinicSearchScreenViewModel{
    @Published var clinics: ClinicService?
    @Published var specialties: [Specialty] = []
    @Published var filteredSpecialties: [Specialty] = []
    @Published var searchText: String = ""

    var coordinator: HomeCoordinatorContact?
    private var apiClient :APIClient?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?

    var displayMode: ClinicSearchDisplayMode
    private var hospitalId: Int?

    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), mode: ClinicSearchDisplayMode = .clinics) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.displayMode = mode

        // If hospital specialties mode, setup specialties
        if case .hospitalSpecialties(let hospitalId, let specialties) = mode {
            self.hospitalId = hospitalId
            self.specialties = specialties
            self.filteredSpecialties = specialties
            setupSearchSubscription()
        }
    }

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
}
extension ClinicSearchScreenViewModel{
    func fetchClincs(){
    
        apiClient?.fetchData(from: URL(string:"https://Backend.allo-doctor.com/api/admin/service/with-relations?id=2")!,as: ClinicResponseData.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                   break
                case .failure(let error):
                  self.errorMessage = "Failed to fetch clinics: \(error.localizedDescription)"
                }
            }, receiveValue: { clinincsResponse in
                self.clinics = clinincsResponse.data
                print(clinincsResponse)
            })
            .store(in: &cancellables)
    }
    func navToClinicProfile(clinicID:String) {
        coordinator?.showClinicProfile(clinicID: clinicID)
    }

    func navigateToSpecialty(specialty: Specialty) {
        guard let hospitalId = hospitalId else { return }
        coordinator?.showDoctorsForHospital(hospitalId: hospitalId, specialtyId: specialty.id, serviceId: 2)
    }
}
