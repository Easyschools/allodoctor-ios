//
//  OneDayCareAppointmentsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 27/12/2024.
//

import Foundation
class OneDayCareAppointmentsViewModel{ 
    // MARK: - Proprties
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var ServiceId: Int?
    @Published var operationData: OperationData?
    @Published var generatedDates: [String] = []
    @Published var generatedModels: [OneDayCareAppointmentsModel.DayAvailability] = []
    @Published var hospitalAppointment : OneDayCareAppointmentsModel?
   
    var lastGeneratedDate: Date? = nil
    // MARK: - ViewModel init
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), ServiceId: Int) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.ServiceId = ServiceId
    }
    
}

// MARK: - Fetching Pharmacy Cart
extension OneDayCareAppointmentsViewModel {
    func getAppointmentsData() {
        getAppointmentsData(serviceId: ServiceId ?? 0)
    }
    
    private func getAppointmentsData(serviceId: Int) {
        let router = APIRouter.fetchOneDayCareServiceDays(ServiceId:serviceId)
        print (router.url)
        apiClient.fetchData(from: router.url, as: OneDayCareAppointmentsModel.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch operation Appointments: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] appointment in
                let hospitalAppointment = appointment
                let appointments = appointment.data.days
                let (generatedSchedule, generatedDates) = self?.rearrangeDaysAndGenerate(data: appointments ?? []) ?? ([], [])
                
                self?.hospitalAppointment = hospitalAppointment
                self?.generatedModels = generatedSchedule
                self?.generatedDates = generatedDates
            })
            .store(in: &cancellables)
    }}
  
    extension OneDayCareAppointmentsViewModel {
        func rearrangeDaysAndGenerate(data: [OneDayCareAppointmentsModel.DayAvailability]) -> ([OneDayCareAppointmentsModel.DayAvailability], [String]) {
            let weeksToGenerate = 1
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM YYYY"
            formatter.timeZone = TimeZone(identifier: "Africa/Cairo")
            
            let calendar = Calendar(identifier: .gregorian)
            var components = DateComponents()
            components.timeZone = TimeZone(identifier: "Africa/Cairo")
            let now = Date()
            
            // Get the current date in Egypt timezone
            guard let egyptDate = calendar.date(byAdding: components, to: now),
                  let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: egyptDate) else {
                return (data, [])
            }
            
            // Get the current weekday in Egypt
            let weekday = calendar.component(.weekday, from: egyptDate)
            let currentDayId = weekday
            
            guard let currentIndex = data.firstIndex(where: { $0.day?.id == currentDayId }) else {
                return (data, [])
            }
            
            let rearranged = Array(data[currentIndex...]) + Array(data[..<currentIndex])
            var newModels: [OneDayCareAppointmentsModel.DayAvailability] = []
            var newDates: [String] = []
            
            // Create calendar specific to Egypt
            var egyptCalendar = Calendar(identifier: .gregorian)
            egyptCalendar.timeZone = TimeZone(identifier: "Africa/Cairo")!
            
            for week in 0..<weeksToGenerate {
                for i in 0..<7 {
                    guard let nextDate = egyptCalendar.date(byAdding: .day, value: (week * 7) + i, to: startOfDay) else {
                        continue
                    }
                    
                    let formattedDate = formatter.string(from: nextDate)
                    
                    if !generatedDates.contains(formattedDate) {
                        newDates.append(formattedDate)
                        generatedDates.append(formattedDate)
                        
                        let originalIndex = i % rearranged.count
                        let originalDay = rearranged[originalIndex]
                        
                        let newModel = OneDayCareAppointmentsModel.DayAvailability(
                            id: (originalDay.id ?? 0) + (week * 7),
                            availability: originalDay.availability,
                            day: originalDay.day
                        )
                        
                        newModels.append(newModel)
                        generatedModels.append(newModel)
                    }
                }
            }
            
            lastGeneratedDate = egyptCalendar.date(byAdding: .day, value: weeksToGenerate * 7, to: startOfDay)
            return (generatedModels, generatedDates)
        }
    }

extension OneDayCareAppointmentsViewModel{
    func showOneDayCareBooking(date:String,dayServiceId:Int,hospitalData:OneDayCareAppointmentsModel){
        coordinator?.showOneDayCareBooking(dayServiceId: dayServiceId, date: date, hospitalData: hospitalData )
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}
