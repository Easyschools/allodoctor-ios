//
//  SearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/09/2024.
//
import Foundation

enum SearchDisplayMode {
    case globalSearch  // Display all specialties from API
    case hospitalSpecialties(hospitalId: Int, specialties: [Specialty])  // Display hospital's specialties
}

class SearchViewModel {
    // MARK: - Published properties
    @Published var specialties: [AllSpeciality] = []
    @Published var hospitalSpecialties: [Specialty] = []
    @Published var filteredHospitalSpecialties: [Specialty] = []
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var searchResult: [SearchResult] = []


    // MARK: - Private properties
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    var districtId = CurrentValueSubject<Int, Never>(0)

    // MARK: - Public properties
    var coordinator: HomeCoordinatorContact?
    var displayMode: SearchDisplayMode
    private var hospitalId: Int?

    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), mode: SearchDisplayMode = .globalSearch) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.displayMode = mode

        // If hospital specialties mode, setup specialties
        if case .hospitalSpecialties(let hospitalId, let specialties) = mode {
            self.hospitalId = hospitalId
            self.hospitalSpecialties = specialties
            self.filteredHospitalSpecialties = specialties
        }

        setupSearchSubscription()
    }
    
    // MARK: - Private methods
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self = self else { return }
                switch self.displayMode {
                case .globalSearch:
                    if !searchText.isEmpty {
                        self.fetchsearchResults(searchedText: searchText)
                    }
                case .hospitalSpecialties:
                    self.filterHospitalSpecialties(with: searchText)
                }
            }
            .store(in: &cancellables)
    }

    private func filterHospitalSpecialties(with searchText: String) {
        if searchText.isEmpty {
            filteredHospitalSpecialties = hospitalSpecialties
        } else {
            let language = UserDefaultsManager.sharedInstance.getLanguage()
            filteredHospitalSpecialties = hospitalSpecialties.filter { specialty in
                let name = language == .ar ? (specialty.nameAr ?? specialty.name ?? "") : (specialty.nameEn ?? specialty.name ?? "")
                return name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func clearSearchResults() {
        searchResult = []
    }
    
    // MARK: - Public methods
    func fetchSpecialties(isPaginate:Int) {
        let router = APIRouter.fetchSpecialities(isPaginate:isPaginate)
        print(router.url)
        apiClient.fetchAllPages(from: router.url, as: AllSpecialityResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Specialities: \(error.localizedDescription)"
                    print(self?.errorMessage ?? "")
                }
            }, receiveValue: { [weak self] speciality in
                self?.specialties = speciality
            })
            .store(in: &cancellables)
    }
    

    func fetchsearchResults(searchedText: String) {
        let encodedText = searchedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Build URL string conditionally based on districtId value
        let baseURL = "https://Backend.allo-doctor.com/api/admin/filter/home-filter?is_paginate=10&search=\(encodedText)"
        let urlString: String
        
        if districtId.value == 0 {
            // Don't include district_id parameter when it's 0
            urlString = baseURL
        } else {
            // Include district_id parameter when it has a valid value
            urlString = "\(baseURL)&district_id=\(districtId.value)"
        }
        
        print(urlString)
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        apiClient.fetchData(from: url, as: SearchResultResponseData.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Search Results: \(error.localizedDescription)"
                    print(error)
                }
            }, receiveValue: { [weak self] searchResponse in
                self?.searchResult = searchResponse.data
            })
            .store(in: &cancellables)
    }
    func getAllAreaOfResidence() {
        let router = APIRouter.fetchCities
        apiClient.fetchData(from: router.url, as: CityDataResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Cities: \(error.localizedDescription)"
                }
            }, receiveValue: { citiesResponse in
                self.cities = citiesResponse.data ?? []
            })
            .store(in: &cancellables)
    }
    // MARK: - Navigation methods
    func navBackTo() {
        coordinator?.navigateBack()
    }
    
    func navtoDoctorSearch(specialityId:String) {
        coordinator?.showDoctorSearch(specialityId:specialityId, externalClinicServiceId: "", doctorPlace: .doctorClinics)
    }

    func navToHospitalDoctorSearch(specialtyId: Int) {
        guard let hospitalId = hospitalId else { return }
        coordinator?.showDoctorsForHospital(hospitalId: hospitalId, specialtyId: specialtyId)
    }

    func navToDoctor(id:String){
        coordinator?.showDoctorProfile(doctorID: id, doctorPlace: .doctorClinics)
    }
    func navToClinicProfile (id:String){
        coordinator?.showClinicProfile(clinicID: id)
    }
}
