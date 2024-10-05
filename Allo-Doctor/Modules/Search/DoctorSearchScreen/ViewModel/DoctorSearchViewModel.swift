//
//  DoctorSearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit
import Combine

class DoctorSearchViewModel {
    @Published var doctors: [DoctorData] = []
    @Published var searchText = ""
    var coordinator: HomeCoordinatorContact?
    private var apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        setupSearchSubscription()
    }
    
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.fetchDoctors(searchedText: searchText)
            }
            .store(in: &cancellables)
    }
    
    func fetchDoctors(searchedText: String) {
        let encodedText = searchedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/doctor/all?is_paginate=30&search=\(encodedText)")!
        
        apiClient.fetchData(from: url, as: DoctorsResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch doctors: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] doctorResponse in
                self?.doctors = doctorResponse.data
                print("Fetched \(doctorResponse.data.count) doctors")
            })
            .store(in: &cancellables)
    }
    
    func navToDoctorProfile(doctorID: String) {
        coordinator?.showDoctorProfile(doctorID: doctorID)
    }
}
