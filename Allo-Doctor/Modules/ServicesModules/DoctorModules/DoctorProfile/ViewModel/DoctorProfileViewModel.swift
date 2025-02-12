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
    private var currentDate = Date()
    var allAppointments: [DoctorAppointment] = []
    private let calendar = Calendar.current
    private var maxId: Int = 0
    
    // New pagination properties
    private var appointmentPages: [[DoctorAppointment]] = []
    private var currentPageIndex = 0
    
    // Published properties
    @Published var favData: [FavData]?
    @Published var doctorData: DoctorProfile?
    @Published var errorMessage: String?
    @Published var displayedData: [DoctorAppointment] = []
    @Published var isLoading = false
    
    // Private properties
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    private let itemsPerPage = 3
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, doctorId: String, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.doctorId = doctorId
        self.apiClient = apiClient
    }
    
    // MARK: - Private Methods
    private func getWeekday(_ dayName: String) -> Int {
        let weekdayMap = ["Sunday": 1, "Monday": 2, "Tuesday": 3, "Wednesday": 4, "Thursday": 5, "Friday": 6, "Saturday": 7]
        return weekdayMap[dayName] ?? 1
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
                print(self?.doctorData?.doctorServiceSpecialtyIds?[0].appointments ?? "not available")
            }).store(in: &cancellables)
    }
    
    func fetchDoctorFavourite() {
        let router = APIRouter.isFavourite(entity: "doctor", id: doctorId.toInt() ?? 0)
        apiClient.fetchData(from: router.url, as: DoctorsFav.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            }, receiveValue: { [weak self] doctorResponse in
                self?.favData = doctorResponse.data
            }).store(in: &cancellables)
    }
    
    // MARK: - Appointment Generation Methods
    func generateNextThreeDates(from baseAppointments: [DoctorAppointment]) -> [DoctorAppointment] {
        guard !baseAppointments.isEmpty else { return [] }
        
        // Check if we have a next stored page
        if currentPageIndex < appointmentPages.count - 1 {
            currentPageIndex += 1
            return appointmentPages[currentPageIndex]
        }
        
        // Generate new appointments
        let newAppointments = generateNewAppointments(from: baseAppointments)
        
        // Store the new page
        appointmentPages.append(newAppointments)
        currentPageIndex = appointmentPages.count - 1
        
        return newAppointments
    }
    
    private func generateNewAppointments(from baseAppointments: [DoctorAppointment]) -> [DoctorAppointment] {
        let today = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Initialize if first time
        if allAppointments.isEmpty {
            allAppointments = baseAppointments
            maxId = baseAppointments.map { $0.appointmentDayHourId }.max() ?? 0

            let todayString = dateFormatter.string(from: today)
            if baseAppointments.contains(where: { $0.day.date == todayString }) {
                currentDate = today
            } else {
                let firstDay = baseAppointments[0].day.nameEn
                let targetWeekday = getWeekday(firstDay)
                let currentWeekday = calendar.component(.weekday, from: today)
                var daysToAdd = targetWeekday - currentWeekday
                if daysToAdd < 0 {
                    daysToAdd += 7
                }
                currentDate = calendar.date(byAdding: .day, value: daysToAdd, to: today) ?? today
            }
        } else {
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? today
        }

        let dayPattern = baseAppointments.map { $0.day.nameEn }
        var nextDate = currentDate
        var weekCount = 0
        var newAppointments: [DoctorAppointment] = []

        while weekCount < 3 {
            for (index, templateDay) in dayPattern.enumerated() {
                let template = baseAppointments[index]
                maxId += 1

                let targetWeekday = getWeekday(templateDay)
                let currentWeekday = calendar.component(.weekday, from: nextDate)
                var daysToAdd = targetWeekday - currentWeekday

                if daysToAdd < 0 {
                    daysToAdd += 7
                } else if daysToAdd == 0 && index > 0 {
                    daysToAdd = 7
                }

                nextDate = calendar.date(byAdding: .day, value: daysToAdd, to: nextDate) ?? nextDate
                let nextDateString = dateFormatter.string(from: nextDate)
                
                if allAppointments.contains(where: { $0.day.date == nextDateString }) {
                    continue
                }

                let newDay = DoctorDay(
                    id: template.day.id,
                    nameEn: template.day.nameEn,
                    nameAr: template.day.nameAr,
                    name: template.day.name,
                    available: template.day.available,
                    date: nextDateString
                )

                let newHours = template.hour.enumerated().map { hourIndex, hour in
                    DoctorHour(
                        appointmentDayHourId: maxId + hourIndex,
                        id: hour.id,
                        from: hour.from,
                        to: hour.to
                    )
                }

                let newAppointment = DoctorAppointment(
                    appointmentDayHourId: maxId,
                    day: newDay,
                    hour: newHours
                )

                newAppointments.append(newAppointment)
            }
            weekCount += 1
        }

        allAppointments.append(contentsOf: newAppointments)
        currentDate = nextDate

        return newAppointments
    }
    
    func getPreviousAppointments() -> [DoctorAppointment]? {
        guard currentPageIndex > 0 else { return nil }
        currentPageIndex -= 1
        return appointmentPages[currentPageIndex]
    }
    
    // MARK: - Navigation Methods
    func navToAppointmentsScreen(doctor: DoctorProfile, date: String, day: String, doctorServiceSpecialityId: Int) {
        coordinator?.showDoctorAppointmentsScreen(
            docotor: doctor,
            date: date,
            day: day,
            doctorServiceSpecialtyId: doctorServiceSpecialityId
        )
    }
    
    // MARK: - Favorite Methods
    func addToFav() {
        let favRequest = FavouritesModel(
            favoritable_entity: "doctor",
            favoritable_id: doctorId.toInt() ?? 0
        )
        addToFav(request: favRequest)
    }
    
    private func addToFav(request: FavouritesModel) {
        let router = APIRouter.addToFavoutites
        apiClient.postData(to: router.url, body: request, as: FavouritesModelResponse.self)
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
    
    // MARK: - Reset Method
    func reset() {
        currentDate = Date()
        allAppointments.removeAll()
        appointmentPages.removeAll()
        currentPageIndex = 0
        maxId = 0
    }
}
