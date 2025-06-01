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
init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
 self.coordinator = coordinator
 self.apiClient = apiClient
}
}
extension IntensiveCareUnitsViewModel{
    func navToIntensiveCareBooking(){
        coordinator?.showIntensiveCare(selectedUnit: selectedUnit.value)
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}
