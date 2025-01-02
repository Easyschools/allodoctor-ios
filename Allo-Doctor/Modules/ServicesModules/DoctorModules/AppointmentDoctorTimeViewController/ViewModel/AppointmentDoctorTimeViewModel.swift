//
//  AppointmentDoctorTimeViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/10/2024.
//

import UIKit
class AppointmentDoctorTimeViewModel{
    // MARK: - proprties
    var coordinator:HomeCoordinatorContact?
    private var appointmentDay : String?
    @Published var doctorData : [DoctorAppointmentAvailable]?
    @Published var errorMessage: String?
    @Published var doctor: DoctorProfile?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    // MARK: - initlizer
    init(coordinator: HomeCoordinatorContact? = nil,doctor:DoctorProfile,apiClient:APIClient = APIClient()) {
        self.coordinator = coordinator
        self.doctor = doctor
        self.apiClient = apiClient
    }
}
extension AppointmentDoctorTimeViewModel{
    private func fetchDoctorAppointment(doctorID:String){
        let router = APIRouter.fetchDoctorAppointment(doctorId: 56, specialtyId: 1, serviceId: 1, day: "monday", date: "")
        apiClient.fetchData(from: router.url, as: DoctorAppointmentsResponse.self)
            .sink(receiveCompletion: { [self]completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    print ("error")
                    self.errorMessage = error.localizedDescription
                }
            } , receiveValue: { doctorResponse in
                self.doctorData = doctorResponse.data
                
            }).store(in: &cancellables)

        
    }
    func fetchDoctorData(){
      
    }
    
}
extension AppointmentDoctorTimeViewModel{
//    func navToDoctorConfirmation (doctorData:DoctorAppoinments,appointmentDay:"",appointmentHour:Hours){
//        coordinator?.showDoctorConfirmationScreen(doctorData: doctorData, appointmentDay: appointmentDay, appoinmentHour: appointmentHour)
//    }
    func navigationback()
    {
        coordinator?.navigateBack()
    }
}
