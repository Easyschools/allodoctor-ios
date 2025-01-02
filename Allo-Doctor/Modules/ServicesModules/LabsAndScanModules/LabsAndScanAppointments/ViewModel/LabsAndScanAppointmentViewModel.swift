//
//  LabsAndScanAppointmentViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import Foundation
class LabsAndScanAppointmentViewModel{
    var coordinator:HomeCoordinatorContact?
   @Published var tests : [Test]?
   @Published var errorMessage: String?
   private var cancellables = Set<AnyCancellable>()
   private var apiClient = APIClient()
   init(coordinator: HomeCoordinatorContact? = nil,apiClient:APIClient = APIClient()) {
       self.coordinator = coordinator
       self.apiClient = apiClient
//       self.tests = tests
   }
}
