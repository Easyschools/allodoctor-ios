//
//  OneDayCareBookingViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 28/12/2024.
//

import Foundation
class OneDayCareBookingViewModel{  
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    var nameSubject = CurrentValueSubject<String, Never>(  UserDefaultsManager.sharedInstance.getUserName() ?? "")
    var phoneSubject = CurrentValueSubject<String, Never>(  UserDefaultsManager.sharedInstance.getMobileNumber() ?? "")
    @Published var status: BookingStatus?
    @Published var operationResponse: ConfirmOperationResponse?
    private var dayServiceId: Int?
    @Published var hospitalData:OneDayCareAppointmentsModel
    var date: String?
    var infoServiceId: Int?
    // Dependency Injection
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),dayServiceId: Int,date:String ,hospitalData:OneDayCareAppointmentsModel, infoServiceId: Int? = nil) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.dayServiceId = dayServiceId
        self.hospitalData = hospitalData
        self.date = date
        self.infoServiceId = infoServiceId

    }
}

// MARK: - Public Methods
extension OneDayCareBookingViewModel {
    func createBooking() {
        let operationBookingRequest = ConfirmOneDayRequest(
            name:nameSubject.value,
            phone: phoneSubject.value,
            info_day_service_id :dayServiceId,
            date: date,
            info_service_id: infoServiceId
        )
        operationBooking(request: operationBookingRequest)
        
    }
    
    func operationBooking(request: ConfirmOneDayRequest) {
        NetworkManagerAlamofire.shared.postFormData(
            endpoint: "/admin/day-service/booking",
            params: request,
            responseType: ConfirmOneDayRequestResponse.self
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Booking Response: \(response)")
                    self?.status = .success
                case .failure(let error):
                    print("Booking Error: \(error)")
                    self?.status = .failure
                }
            }
        }
    }
    

}

// MARK: - Private Helpers
extension OneDayCareBookingViewModel {
    private func handleError(_ error: APIError) -> String {
        switch error {
        case .network(let description):
            return "Network error: \(description)"
        case .decoding(let description):
            return "Decoding error: \(description)"
        case .server(let message):
            return "Server error: \(message)"
        case .unknown:
            return "An unknown error occurred. Please try again later."
        }
    }
}
extension OneDayCareBookingViewModel {
    func navBack(){
        coordinator?.navigateBack()
    }
    func navToHome(){
        coordinator?.navigateToRoot()
    }
   
}
