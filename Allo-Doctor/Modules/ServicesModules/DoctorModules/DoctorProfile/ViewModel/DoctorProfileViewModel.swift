//
//  DoctorProfileViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/09/2024.
//
//

import Foundation
class DoctorProfileViewModel {
    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var doctorId: String
    @Published var doctorData: DoctorProfile?
    @Published var errorMessage: String?
    @Published var displayedData: [DoctorAppointment] = []
    @Published var generatedDates: [Date] = []
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    private var currentPage = 0
    private let itemsPerPage = 3
    @Published var isLoading = false
    var allGeneratedDates: [Date] = []
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, doctorId: String, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.doctorId = doctorId
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    func fetchDoctorData() {
        let url = URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/doctor/get?id=\(doctorId)&web=1")!
        apiClient.fetchData(from: url, as: DoctorProfileResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            }, receiveValue: { [weak self] doctorResponse in
                self?.doctorData = doctorResponse.data
                self?.loadInitialData()
            }).store(in: &cancellables)
    }
    
    // MARK: - Data Loading Methods
    private func loadInitialData() {
        currentPage = 0
        allGeneratedDates.removeAll()
        loadPageData()
    }
    
    private func loadPageData() {
        guard let appointmentData = doctorData?.appointments else {
            print("No appointment data available.")
            return
        }
        
        // Create dictionary of appointments grouped by day
        var appointmentsByDay: [String: DoctorAppointment] = [:]
        for appointment in appointmentData {
            appointmentsByDay[appointment.day.nameEn ?? ""] = appointment
        }
        
        // Get all unique allowed days
        let allowedDays = Array(appointmentsByDay.keys)
        print("Allowed days for appointments: \(allowedDays)")
        
        // Generate dates based on all allowed days
        let newDates = generateNextDates(from: allowedDays)
        
        // Update the displayed appointments based on these dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        // Match appointments with generated dates
        let relevantAppointments = newDates.compactMap { date -> DoctorAppointment? in
            let dayName = dateFormatter.string(from: date)
            return appointmentsByDay[dayName]
        }
        
        displayedData = relevantAppointments
        generatedDates = newDates
        allGeneratedDates.append(contentsOf: newDates)
        
        print("Generated dates for current page: \(newDates)")
        print("Total generated dates: \(allGeneratedDates)")
    }
    
    private func generateNextDates(from allowedDays: [String]) -> [Date] {
        var nextDates: [Date] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let calendar = Calendar.current
        let startingDate = allGeneratedDates.last ?? Date()
        var currentDate = calendar.date(byAdding: .day, value: 1, to: startingDate) ?? startingDate
        
        // Generate next set of dates for all available days
        while nextDates.count < itemsPerPage {
            let dayName = dateFormatter.string(from: currentDate)
            
            if allowedDays.contains(dayName) {
                nextDates.append(currentDate)
            }
            
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            }
        }
        
        return nextDates
    }
    
    func loadNextData() {
        guard let appointmentData = doctorData?.appointments, !appointmentData.isEmpty else {
            print("No appointment data available for loadNextData.")
            return
        }
        
        currentPage += 1
        print("Loading next page: \(currentPage)")
        loadPageData()
    }
    
    func loadPreviousData() {
        guard currentPage > 0, !allGeneratedDates.isEmpty else {
            print("Already at the first page.")
            return
        }
        
        // Remove last set of dates
        allGeneratedDates.removeLast(min(itemsPerPage, allGeneratedDates.count))
        
        currentPage -= 1
        print("Loading previous page: \(currentPage)")
        
        if currentPage == 0 {
            loadInitialData()
        } else {
            loadPageData()
        }
    }
    
    // MARK: - Navigation
    func navToAppointmentsScreen(doctor: DoctorProfile) {
        coordinator?.showDoctorAppointmentsScreen(docotor: doctor)
    }
}
