//
//  IntensiveCareUnitsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/12/2024.
//

import Foundation
class IntensiveCareUnitsViewModel{
internal var selectedUnit = CurrentValueSubject<String, Never>("")
var coordinator: HomeCoordinatorContact?
private var cancellables = Set<AnyCancellable>()
@Published var errorMessage: String?
private var apiClient = APIClient()
var infoServiceId: Int?
init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), infoServiceId: Int? = nil) {
 self.coordinator = coordinator
 self.apiClient = apiClient
 self.infoServiceId = infoServiceId
}
}
extension IntensiveCareUnitsViewModel{
    func navToIntensiveCareBooking(){
        coordinator?.showIntensiveCare(selectedUnit: selectedUnit.value, infoServiceId: infoServiceId)
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}
