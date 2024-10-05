//
//  DoctorProfileViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/09/2024.
//

import Foundation
import UIKit
class DoctorProfileViewModel{
    var coordinator:HomeCoordinatorContact?
    private var doctorId : String
    @Published var doctorData : DoctorData?
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
  
    init(coordinator: HomeCoordinatorContact? = nil,doctorId:String,apiClient:APIClient = APIClient()) {
        self.coordinator = coordinator
        self.doctorId = doctorId
        self.apiClient = apiClient
    }
    
}
extension DoctorProfileViewModel{
    private func fetchDoctorData(doctorID:String){
       
        let url = URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/doctor/get?id=\(doctorID)")!
        apiClient.fetchData(from:url, as: DoctorResponse.self)
            .sink(receiveCompletion: {completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } , receiveValue: { doctorResponse in
                self.doctorData = doctorResponse.data
            }).store(in: &cancellables)
    }
}
extension DoctorProfileViewModel{
    func fetchDoctorData(){
        fetchDoctorData(doctorID: doctorId)
    }
}
