//
//  LabsAndScanAppointmentViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//

import Foundation
class LabsAndScanAppointmentViewModel{
   private var coordinator:HomeCoordinatorContact?
   @Published var tests : [LabTestType]
   @Published var errorMessage: String?
   @Published var testType:String?
   @Published var type : String?
   @Published var labAppointment:LapAppointmentsData?
   @Published var labId : Int
   private var cancellables = Set<AnyCancellable>()
   private var apiClient = APIClient()
    init(coordinator: HomeCoordinatorContact? = nil,apiClient:APIClient = APIClient(),tests:[LabTestType],labId:Int,type:String) {
       self.coordinator = coordinator
       self.apiClient = apiClient
       self.tests = tests
       self.labId = labId
       self.type = type
   }
}
extension LabsAndScanAppointmentViewModel{
    func getAppointments(date:String,testType:String,day:String){
        let router = APIRouter.fetchLabAppoinment(labId:labId , day:day, date: date.convertArabicDateToEnglish() ?? "", type: testType)
        apiClient.fetchData(from:router.url, as: LapAppointmentResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print ("error")
                    self.errorMessage = "Failed to fetch Labs appointments: \(error.localizedDescription)"
                    print (self.errorMessage!)
                }
            },receiveValue: { labResponse in
                self.labAppointment = labResponse.data
            
            })
            .store(in: &cancellables)
    }
    func getCurrentDate(format: String = "yyyy-MM-dd") -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: currentDate)
    }
    func getCurrentDay(format: String = "EEEE") -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: currentDate)
    }

    func getDayOfWeekInCairo(from dateString: String, withFormat format: String = "yyyy-MM-dd") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format // Input date format
        dateFormatter.timeZone = TimeZone(identifier: "Africa/Cairo")
        
        // Convert string to Date
        guard let date = dateFormatter.date(from: dateString) else {
            return nil // Return nil if the date is invalid
        }
        
        // Format date to return day name
        dateFormatter.dateFormat = "EEEE" // Output full day name
        return dateFormatter.string(from: date)
    }


}
extension LabsAndScanAppointmentViewModel{
    func navtoLabBooking(hourId:Int,dayId:Int,date:String){
        coordinator?.showLabsAndScanBooking(tests: tests, hourId: hourId, dayId: dayId, date:date , labId: labId, bookingType:testType ?? "home")
    }
    func navback(){
        coordinator?.navigateBack()
    }
}
