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
    @Published var appoinmentHour : DoctorAppointmentHour?
    @Published var appoinmentDay : String?
    @Published var date : String?
    @Published var errorMessage: String?
    var nameSubject = CurrentValueSubject<String, Never>("")
    var numberSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()
    @Published var doctorServiceSpecialtyId:Int
    private var apiClient = APIClient()
    init(coordinator: HomeCoordinatorContact? = nil,doctorData:DoctorProfile,appointmentDay:String,apiClient:APIClient = APIClient(),appoinmentHour:DoctorAppointmentHour,doctorServiceSpecialtyId:Int,date:String) {
        self.coordinator = coordinator
        self.doctorData = doctorData
        self.apiClient = apiClient
        self.appoinmentDay = appointmentDay
        self.appoinmentHour = appoinmentHour
        self.doctorServiceSpecialtyId = doctorServiceSpecialtyId
        self.date = date
    }
    func createBooking() {
        let bookingRequest = BookingRequest(
                     name:nameSubject.value,
                     phone: numberSubject.value,
                    appointmentDayHourId:appoinmentHour?.appointmentDayHoursId ?? 0,
                    availability: 1, userId:UserDefaultsManager.sharedInstance.getUserId() ?? 0,
                    date:date ?? "", doctorServiceSpecialtyId:doctorServiceSpecialtyId
        )
        print(bookingRequest)
        confirmBooking(request: bookingRequest)
        
    }
    
    func confirmBooking(request: BookingRequest) {
        let router = APIRouter.bookDoctor(request)
        apiClient.postData(to: router.url, body: request, as: BookingResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                 
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    
                }
            }, receiveValue: { response in
                print("Registration Response: \(response)")
                
            })
            .store(in: &cancellables)
        
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

