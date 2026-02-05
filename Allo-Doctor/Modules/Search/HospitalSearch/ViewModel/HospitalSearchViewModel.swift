//
//  HospitalSearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/09/2024.
//

import Foundation
import Combine

enum HospitalDisplayMode {
    case hospitals  // Display list of hospitals
    case specialties(hospital: HospitalInfoService)  // Display specialties of selected hospital
}

class HospitalSearchViewModel{
    @Published var hospitals: HospitalData?
    @Published var hospitalsList: [HospitalInfoService] = []
    @Published var filteredHospitals: [HospitalInfoService] = []
    @Published var specialties: [Specialty] = []
    @Published var filteredSpecialties: [Specialty] = []
    @Published var searchText: String = ""
    @Published var cities: [City] = []
    @Published var selectedDistrictId: Int?
    @Published var selectedDistrictName: String?

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

        // Setup search subscription for both modes
        setupSearchSubscription()

        // If displaying specialties, extract them from hospital
        if case .specialties(let hospital) = mode {
            self.selectedHospital = hospital
            self.specialties = hospital.specialties
            self.filteredSpecialties = hospital.specialties
        }
    }

    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self = self else { return }
                switch self.displayMode {
                case .hospitals:
                    self.filterHospitals(with: searchText)
                case .specialties:
                    self.filterSpecialties(with: searchText)
                }
            }
            .store(in: &cancellables)
    }

    private func filterHospitals(with searchText: String) {
        if searchText.isEmpty {
            filteredHospitals = hospitalsList
        } else {
            let language = UserDefaultsManager.sharedInstance.getLanguage()
            filteredHospitals = hospitalsList.filter { hospital in
                let name = language == .ar ? (hospital.nameAr ?? hospital.name ?? "") : (hospital.nameEn ?? hospital.name ?? "")
                return name.localizedCaseInsensitiveContains(searchText)
            }
        }
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
        // Fetch hospitals using the APIRouter
        let router: APIRouter
        if let districtId = selectedDistrictId {
            router = APIRouter.fetchHospitalsWithDistrict(isPaginate: 50, serviceId: 1, districtId: districtId)
        } else {
            router = APIRouter.fetchHospitals(isPaginate: 50, serviceId: 1)
        }
        apiClient?.fetchData(from: router.url, as: HospitalResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                   break
                case .failure(let error):
                  self?.errorMessage = "Failed to fetch hospitals: \(error.localizedDescription)"
                  print("Error fetching hospitals: \(error)")
                }
            }, receiveValue: { [weak self] hospitalResponse in
                self?.hospitalsList = hospitalResponse.data
                self?.filteredHospitals = hospitalResponse.data
                print("Fetched \(hospitalResponse.data.count) hospitals")
            })
            .store(in: &cancellables)
    }

    func fetchCities() {
        let router = APIRouter.fetchCities
        apiClient?.fetchData(from: router.url, as: CityDataResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch cities: \(error.localizedDescription)"
                    print("Error fetching cities: \(error)")
                }
            }, receiveValue: { [weak self] citiesResponse in
                self?.cities = citiesResponse.data ?? []
            })
            .store(in: &cancellables)
    }

    func selectDistrict(id: Int, name: String) {
        selectedDistrictId = id
        selectedDistrictName = name
        fetchHospitals()
    }

    func clearDistrictFilter() {
        selectedDistrictId = nil
        selectedDistrictName = nil
        fetchHospitals()
    }

    func navigateToHospitalFromList(hospital: HospitalInfoService) {
        // Navigate to hospital specialties when a hospital is selected
        coordinator?.showHospitalSpecialties(hospital: hospital)
    }

    // Navigation for specialties mode
    func navigateToSpecialty(specialty: Specialty) {
        guard let hospital = selectedHospital else { return }
        coordinator?.showDoctorsForHospital(hospitalId: hospital.id, specialtyId: specialty.id, serviceId: nil)
    }

    func navigateBack() {
        coordinator?.navigateBack()
    }
}
