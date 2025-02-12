//
//  HospitalSearchViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/09/2024.
//

import Foundation
class HospitalSearchViewModel{ 
    @Published var hospitals: HospitalData?
    var coordinator: HomeCoordinatorContact?
    private var apiClient :APIClient?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }
}
extension HospitalSearchViewModel{
    func fetchHospitals(){
        let url = URL(string:"https://allodoctor-backend.developnetwork.net/api/admin/info-service/get?id=1)") ?? URL(string: "")!
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

        coordinator?.showDoctorSearch(specialityId: "1", externalClinicServiceId: "")
    }
}
