//
//  OperationAppointmentsViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 19/11/2024.
//

import Foundation
class OperationAppointmentsViewModel{   
    // MARK: - Proprties
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    @Published var operationServiceId: Int?
    @Published var operationData: OperationData?
    @Published var generatedDates: [String] = []
    @Published var generatedModels: [HospitalSchedule] = []
    @Published var hospitalAppointment : [HospitalSchedule]?
    var hospitalData:OperationInfoServiceWrapper
    var lastGeneratedDate: Date? = nil
    // MARK: - ViewModel init
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), operationServiceId: Int,hospitalData:OperationInfoServiceWrapper) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.operationServiceId = operationServiceId
        self.hospitalData = hospitalData
    }
    
}

// MARK: - Fetching Pharmacy Cart
extension OperationAppointmentsViewModel {
    func getOperationData() {
        getOperationData(operationServiceId: operationServiceId ?? 0)
    }
    
    private func getOperationData(operationServiceId: Int) {
        let router = APIRouter.fetchOperationAppointments(operationServiceId: operationServiceId)
        print (router.url)
        apiClient.fetchData(from: router.url, as: HospitalScheduleResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.errorMessage = "Failed to fetch operation Appointments: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] appointment in
                guard let hospitalAppointment = appointment.data else { return }
                let (generatedSchedule, generatedDates) = self?.rearrangeDaysAndGenerate(data: hospitalAppointment) ?? ([], [])
                
                self?.hospitalAppointment = hospitalAppointment
                self?.generatedModels = generatedSchedule
                self?.generatedDates = generatedDates
            })
            .store(in: &cancellables)
    }}
extension OperationAppointmentsViewModel{
  
        func rearrangeDaysAndGenerate(data: [HospitalSchedule]) -> ([HospitalSchedule], [String]) {
            let weeksToGenerate: Int = 1
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM YYYY"
            formatter.timeZone = TimeZone(identifier: "Africa/Cairo")

            let calendar = Calendar(identifier: .gregorian)
            let now = Date()
            let startOfDay = calendar.startOfDay(for: now)
            let weekday = calendar.component(.weekday, from: now)
            
            // Convert Gregorian weekday (Sun=1) to Egypt weekday (Sun=1)
            // Map Tuesday (3) to id 3
            let currentDayId = weekday

            guard let currentIndex = data.firstIndex(where: { $0.day?.id == currentDayId }) else {
                return (data, [])
            }

            let rearranged = Array(data[currentIndex...]) + Array(data[..<currentIndex])
            var newModels: [HospitalSchedule] = []
            var newDates: [String] = []

            for week in 0..<weeksToGenerate {
                for i in 0..<7 {
                    let nextDate = calendar.date(byAdding: .day, value: (week * 7) + i, to: startOfDay)!
                    let formattedDate = formatter.string(from: nextDate)
                    
                    if !generatedDates.contains(formattedDate) {
                        newDates.append(formattedDate)
                        generatedDates.append(formattedDate)
                        
                        let originalIndex = i % rearranged.count
                        let newModel = HospitalSchedule(
                            id: rearranged[originalIndex].id ?? 0 + (week * 7),
                            operationServiceID: rearranged[originalIndex].operationServiceID,
                            day: rearranged[originalIndex].day,
                            from: rearranged[originalIndex].from,
                            to: rearranged[originalIndex].to,
                            availability: rearranged[originalIndex].availability
                        )
                        newModels.append(newModel)
                        generatedModels.append(newModel)
                    }
                }
            }

            lastGeneratedDate = calendar.date(byAdding: .day, value: weeksToGenerate * 7, to: startOfDay)
            return (generatedModels, generatedDates)
        }
    }
extension OperationAppointmentsViewModel{
    func showOperationBooking(date:String){
        coordinator?.showOperationBooking(operationServiceId: operationServiceId ?? 0, date: date, hospitalData: hospitalData)
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}
