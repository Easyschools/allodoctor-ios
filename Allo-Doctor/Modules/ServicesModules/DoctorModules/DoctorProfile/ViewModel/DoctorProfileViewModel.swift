//
//  DoctorProfileViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/09/2024.
//

enum DoctorPlace {
    case outpatientClinics
    case doctorClinics
}

import Foundation

class DoctorProfileViewModel {
    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var doctorId: String
    private var currentDate = Date()
    var allAppointments: [DoctorAppointment] = []
    private let calendar = Calendar.current
    private var maxId: Int = 0
    var doctorPlace: DoctorPlace
    
    // New pagination properties
    private var currentStartIndex = 0
    private let itemsPerPage = 3
    
    // Published properties
    @Published var favData: [FavData]?
    @Published var doctorData: DoctorProfile?
    @Published var errorMessage: String?
    @Published var displayedData: [DoctorAppointment] = []
    @Published var isLoading = false
    
    // Private properties
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, doctorId: String, apiClient: APIClient = APIClient(), doctorPlace: DoctorPlace) {
        self.coordinator = coordinator
        self.doctorId = doctorId
        self.apiClient = apiClient
        self.doctorPlace = doctorPlace
    }
    
    // MARK: - Private Methods
    private func getWeekday(_ dayName: String) -> Int {
        let weekdayMap = ["Sunday": 1, "Monday": 2, "Tuesday": 3, "Wednesday": 4, "Thursday": 5, "Friday": 6, "Saturday": 7]
        return weekdayMap[dayName] ?? 1
    }
    
    // MARK: - API Methods
    func fetchDoctorData() {
        let url = URL(string: "https://Backend.allo-doctor.com/api/admin/doctor/get?id=\(doctorId)&web=1")!
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
    
    // MARK: - NEW: Show all appointments from API with dates
    func generateNextThreeDates(from baseAppointments: [DoctorAppointment]) -> [DoctorAppointment] {
        guard !baseAppointments.isEmpty else { return [] }
        
        // Initialize all appointments with generated dates on first call
        if allAppointments.isEmpty {
            allAppointments = generateDatesForAppointments(baseAppointments)
            currentStartIndex = 0
        }
        
        // Calculate end index for pagination
        let endIndex = min(currentStartIndex + itemsPerPage, allAppointments.count)
        
        // Return the current page of appointments
        let currentPage = Array(allAppointments[currentStartIndex..<endIndex])
        
        return currentPage
    }
    
    // MARK: - Generate dates for all appointment days (next 26 weeks = ~6 months)
    private func generateDatesForAppointments(_ baseAppointments: [DoctorAppointment]) -> [DoctorAppointment] {
        let today = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var appointmentsWithDates: [DoctorAppointment] = []
        var maxId = baseAppointments.map { $0.appointmentDayHourId }.max() ?? 0
        
        // Generate dates for the next 26 weeks (~6 months)
        for weekOffset in 0..<26 {
            for template in baseAppointments {
                let targetWeekday = getWeekday(template.day.nameEn)
                
                // Calculate the date for this appointment
                var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
                components.weekday = targetWeekday
                components.weekOfYear = (components.weekOfYear ?? 0) + weekOffset
                
                guard let appointmentDate = calendar.date(from: components) else { continue }
                
                // Skip if the date is in the past
                if appointmentDate < calendar.startOfDay(for: today) {
                    continue
                }
                
                let dateString = dateFormatter.string(from: appointmentDate)
                maxId += 1
                
                // Create new appointment with date
                let newDay = DoctorDay(
                    id: template.day.id,
                    nameEn: template.day.nameEn,
                    nameAr: template.day.nameAr,
                    name: template.day.name,
                    available: template.day.available,
                    date: dateString
                )
                
                // Include ALL hours for this appointment
                let newHours = template.hour.map { hour in
                    DoctorHour(
                        appointmentDayHourId: maxId,
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
                
                appointmentsWithDates.append(newAppointment)
            }
        }
        
        // Sort by date
        appointmentsWithDates.sort { appointment1, appointment2 in
            guard let date1 = appointment1.day.date,
                  let date2 = appointment2.day.date else {
                return false
            }
            return date1 < date2
        }
        
        return appointmentsWithDates
    }
    
    // MARK: - Pagination Methods
    func getPreviousAppointments() -> [DoctorAppointment]? {
        guard currentStartIndex > 0 else { return nil }
        
        currentStartIndex -= itemsPerPage
        let endIndex = min(currentStartIndex + itemsPerPage, allAppointments.count)
        
        return Array(allAppointments[currentStartIndex..<endIndex])
    }
    
    func getNextAppointments() -> [DoctorAppointment]? {
        let nextStartIndex = currentStartIndex + itemsPerPage
        guard nextStartIndex < allAppointments.count else { return nil }
        
        currentStartIndex = nextStartIndex
        let endIndex = min(currentStartIndex + itemsPerPage, allAppointments.count)
        
        return Array(allAppointments[currentStartIndex..<endIndex])
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
        currentStartIndex = 0
        maxId = 0
    }
}
