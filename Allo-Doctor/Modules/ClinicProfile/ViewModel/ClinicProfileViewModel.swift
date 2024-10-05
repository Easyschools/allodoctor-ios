//
//  ClinicProfileViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import Foundation
class ClinicProfileViewModel{
    private var cancellables = Set<AnyCancellable>()
    var coordinator:HomeCoordinatorContact?
    private var apiClient = APIClient()
    private var clinicID : String
    @Published var clinicData : Clinic?
    @Published var errorMessage: String?
      init(coordinator: HomeCoordinatorContact? = nil,apiClient:APIClient = APIClient(),clinicID:String) {
          self.coordinator = coordinator
          self.clinicID = clinicID
          self.apiClient = apiClient
      }
}
extension ClinicProfileViewModel{
    private func fetchClinicData(clinicID:String){
        let url = URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/info-service/get?id=\(clinicID)")!
        apiClient.fetchData(from:url, as: ClinicResponse.self)
            .sink(receiveCompletion: {completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } , receiveValue: { clinicDataResponse in
                self.clinicData = clinicDataResponse.data
            }).store(in: &cancellables)
    }
}
extension ClinicProfileViewModel{
    func fetchClinicData(){
        fetchClinicData(clinicID: clinicID)
    }
}

