//
//  OperationConfirmedViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/12/2024.
//

import Foundation
class OperationConfirmedViewModel{
    // MARK: - Proprties
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var operationServiceId: Int?
    @Published var hospitalAppointment : [HospitalSchedule]?
    var hospitalData:OperationInfoServiceWrapper
    var date:String
    // MARK: - ViewModel init
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), operationServiceId: Int,hospitalData:OperationInfoServiceWrapper,date:String) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.operationServiceId = operationServiceId
        self.hospitalData = hospitalData
        self.date = date
    }
    
}
extension OperationConfirmedViewModel{
    func showProcdure(){
        coordinator?.showOperationProcedure(operationServiceId: operationServiceId ?? 0)
    }
}
