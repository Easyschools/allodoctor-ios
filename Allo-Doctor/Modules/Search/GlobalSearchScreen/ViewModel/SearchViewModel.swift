//
//  SearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/09/2024.
//
import Foundation
class SearchViewModel {
    // MARK: - Published properties
    @Published var specialties: [AllSpeciality] = []
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
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        setupSearchSubscription()
    }
    
    // MARK: - Private methods
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] searchText in
                self?.fetchsearchResults(searchedText: searchText)
            }
            .store(in: &cancellables)
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
        let baseURL = "https://allodoctor-backend.developnetwork.net/api/admin/filter/home-filter?is_paginate=10&search=\(encodedText)"
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
    func navToDoctor(id:String){
        coordinator?.showDoctorProfile(doctorID: id, doctorPlace: .doctorClinics)
    }
    func navToClinicProfile (id:String){
        coordinator?.showClinicProfile(clinicID: id)
    }
}
