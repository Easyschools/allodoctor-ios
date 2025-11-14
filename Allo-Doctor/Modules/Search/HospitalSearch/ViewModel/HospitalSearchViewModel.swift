//
//  HospitalSearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/09/2024.
//

import Foundation

enum HospitalDisplayMode {
    case hospitals  // Display list of hospitals
    case specialties(hospital: HospitalInfoService)  // Display specialties of selected hospital
}

class HospitalSearchViewModel{
    @Published var hospitals: HospitalData?
    @Published var specialties: [Specialty] = []
    @Published var filteredSpecialties: [Specialty] = []
    @Published var searchText: String = ""

    var coordinator: HomeCoordinatorContact?
    private var apiClient :APIClient?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?

    var displayMode: HospitalDisplayMode
    var selectedHospital: HospitalInfoService?

    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), mode: HospitalDisplayMode = .hospitals) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.displayMode = mode

        // If displaying specialties, extract them from hospital
        if case .specialties(let hospital) = mode {
            self.selectedHospital = hospital
            self.specialties = hospital.specialties
            self.filteredSpecialties = hospital.specialties
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
extension HospitalSearchViewModel{
    func fetchHospitals(){
        let url = URL(string:"https://Backend.allo-doctor.com/api/admin/info-service/get?id=1)") ?? URL(string: "")!
        apiClient?.fetchData(from:url, as: HospitalData.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                   break
                case .failure(let error):
                  self.errorMessage = "Failed to fetch Labs: \(error.localizedDescription)"
                }
            }, receiveValue: { hospitalResponse in

                self.hospitals = hospitalResponse
            })
            .store(in: &cancellables)
    }

    func navToDoctorsSearch() {
        coordinator?.showDoctorSearch(specialityId: "1", externalClinicServiceId: "", doctorPlace: .outpatientClinics)
    }

    // Navigation for specialties mode
    func navigateToSpecialty(specialty: Specialty) {
        guard let hospital = selectedHospital else { return }
        coordinator?.showDoctorsForHospital(hospitalId: hospital.id, specialtyId: specialty.id)
    }

    func navigateToHospitalSpecialties(hospital: Hospital) {
        // Convert Hospital to HospitalInfoService format if needed
        // For now, navigate to doctor search with hospital context
        coordinator?.showDoctorSearch(specialityId: "", externalClinicServiceId: "", doctorPlace: .outpatientClinics)
    }

    func navigateBack() {
        coordinator?.navigateBack()
    }
}
