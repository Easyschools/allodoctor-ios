//
//  SearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/09/2024.
//

import Foundation

class SearchViewModel {
    // MARK: - Published properties
    @Published var specialties: [Specialty] = []
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var searchResult: [SearchResult] = []
    
    // MARK: - Private properties
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    
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
    
    // MARK: - Public methods
    func fetchSpecialties(id: Int) {
        let router = APIRouter.fetchInfoService(id: id)
        
        apiClient.fetchData(from: router.url, as: HospitalData.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Services: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] speciality in
                self?.specialties = speciality.data.specialties
            })
            .store(in: &cancellables)
    }
    
    func fetchCities() {
        apiClient.fetchData(from: URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/city/all?is_paginate=30")!, as: CityResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch cities: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] citiesResponse in
                self?.cities = citiesResponse.data
                print(self?.cities[1].name ?? "")
            })
            .store(in: &cancellables)
    }
    
    func fetchsearchResults(searchedText: String) {
        let encodedText = searchedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://allodoctor-backend.developnetwork.net/api/admin/filter/home-filter?is_paginate=5&search=\(encodedText)"
        
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
                }
            }, receiveValue: { [weak self] searchResponse in
                self?.searchResult = searchResponse.data
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation methods
    func navBackTo() {
        coordinator?.navigateBack()
    }
    
    func navtoDoctorSearch() {
        coordinator?.showDoctorSearch()
    }
    func navToDoctor(id:String){
        coordinator?.showDoctorProfile(doctorID: id)
    }
}
