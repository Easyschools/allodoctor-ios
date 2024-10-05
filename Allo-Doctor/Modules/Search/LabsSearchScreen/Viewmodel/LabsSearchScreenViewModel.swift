//
//  LabsSearchScreenViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import Foundation
class LabsSearchScreenViewModel{
    @Published var labs: ServiceData?
    @Published var scans: ServiceData?
    var coordinator: HomeCoordinatorContact?
    var screenType : String?
    private var apiClient :APIClient?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient(),screenType:String) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.screenType = screenType
    }
}
extension LabsSearchScreenViewModel{
    private func fetchLabsAndScans(serviceId:String){
        let url = URL(string:"https://allodoctor-backend.developnetwork.net/api/admin/service/with-relations?id=\(serviceId)") ?? URL(string: "")!
        apiClient?.fetchData(from:url, as: ServiceResponseData.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                   break
                case .failure(let error):
                  self.errorMessage = "Failed to fetch Labs: \(error.localizedDescription)"
                }
            }, receiveValue: { labsRespnse in
                self.labs = labsRespnse.data
            })
            .store(in: &cancellables)
    }
    func navToLabsAnsScanProfile(url:String) {
        coordinator?.showLabsAndScanSearchScreen(url: url, type: "labs" )

    }
}
extension LabsSearchScreenViewModel{
    func fetchLabsAndScans(){
        fetchLabsAndScans(serviceId:screenType ?? "17")
    }
}
