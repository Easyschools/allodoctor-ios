//
//  ClinicSearchScreenViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import Foundation
class ClinicSearchScreenViewModel{  
    @Published var clinics: ClinicService?
    var coordinator: HomeCoordinatorContact?
    private var apiClient :APIClient?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
}
extension ClinicSearchScreenViewModel{
    func fetchClincs(){
    
        apiClient?.fetchData(from: URL(string:"https://allodoctor-backend.developnetwork.net/api/admin/service/with-relations?id=2")!,as: ClinicResponseData.self)
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
}
