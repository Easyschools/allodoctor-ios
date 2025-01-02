//
//  BookingConfirmationViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/10/2024.
//

import UIKit
class BookingConfirmationViewModel{  
    private var coordinator:HomeCoordinatorContact?
    @Published var doctorData : DoctorProfile?
    @Published var appoinmentHour : Hour?
    @Published var appoinmentDay : String?
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    init(coordinator: HomeCoordinatorContact? = nil,doctorData:DoctorProfile,appointmentDay:String,apiClient:APIClient = APIClient(),appoinmentHour:Hour) {
        self.coordinator = coordinator
        self.doctorData = doctorData
        self.apiClient = apiClient
        self.appoinmentDay = appointmentDay
        self.appoinmentHour = appoinmentHour
    }
    
}
extension BookingConfirmationViewModel{
    func navBack() {
        coordinator?.navigateBack()
    }
    func navToHome(){
        coordinator?.navigateToRoot()
    }
}
