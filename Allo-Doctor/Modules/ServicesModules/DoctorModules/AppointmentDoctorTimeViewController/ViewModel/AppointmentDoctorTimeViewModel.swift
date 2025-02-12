//
//  AppointmentDoctorTimeViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/10/2024.
//

import UIKit
class AppointmentDoctorTimeViewModel{
    // MARK: - proprties
    private var coordinator:HomeCoordinatorContact?
    private var appointmentDay : String?
    @Published var doctorData : [DoctorAppointmentAvailable]?
    @Published var errorMessage: String?
    @Published var doctor: DoctorProfile?
    @Published var date: String
    @Published var day: String
    @Published var doctorServiceSpecialtyId:Int
    private var cancellables = Set<AnyCancellable>()
    private var apiClient = APIClient()
    // MARK: - initlizer
    init(coordinator: HomeCoordinatorContact? = nil,doctor:DoctorProfile,apiClient:APIClient = APIClient(),date:String,day:String,doctorServiceSpecialtyId:Int) {
        self.coordinator = coordinator
        self.doctor = doctor
        self.apiClient = apiClient
        self.date = date
        self.day = day
        self.doctorServiceSpecialtyId = doctorServiceSpecialtyId
        
    }
}
extension AppointmentDoctorTimeViewModel{
internal func fetchDoctorAppointment(){
    print(doctorServiceSpecialtyId)
        let router = APIRouter.fetchDoctorAppointment(doctorId: doctor?.id ?? 0, specialtyId:doctor?.speciality?[0].id ?? 0, serviceId: doctor?.services?[0].id ?? 0, day: day, date: date)
        apiClient.fetchData(from: router.url, as: DoctorAppointmentAvailableResponse.self)
            .sink(receiveCompletion: {  completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    print (error)
                }
            } , receiveValue: {[weak self] doctorResponse in
                self?.doctorData = doctorResponse.appointments
                
            }).store(in: &cancellables)

        
    }
  
}
extension AppointmentDoctorTimeViewModel{
internal  func navigationback()
    {
        coordinator?.navigateBack()
    }
    internal  func navToBookingScreen(hour:DoctorAppointmentHour,appoimentDayHourId:Int,doctor:DoctorProfile)
        {
            coordinator?.showDoctorConfirmationScreen(doctorData:doctor, appointmentDay: day, appoinmentHour: hour, doctorServiceSpecialtyId: doctorServiceSpecialtyId, date: date)
        }
}

