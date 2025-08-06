//
//  OperationBookingViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/11/2024.
//

import Foundation

class OperationBookingViewModel {
    // MARK: - Properties
    private var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    private var apiClient: APIClient
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    var nameSubject = CurrentValueSubject<String, Never>(  UserDefaultsManager.sharedInstance.getUserName() ?? "")
    var phoneSubject = CurrentValueSubject<String, Never>(  UserDefaultsManager.sharedInstance.getMobileNumber() ?? "")
    @Published var status: BookingStatus?
    @Published var operationResponse: ConfirmOperationResponse?
    private var operationServiceId: Int?
    @Published var hospitalData:OperationInfoServiceWrapper
    var date: String?
    // Dependency Injection
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(),operationServiceId: Int,date:String ,hospitalData:OperationInfoServiceWrapper) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.operationServiceId = operationServiceId
        self.hospitalData = hospitalData
        self.date = date

    }
}

// MARK: - Public Methods
extension OperationBookingViewModel {
    func createBooking() {
        let operationBookingRequest = ConfirmOperationRequest(
            user_name:nameSubject.value,
            phone: phoneSubject.value,
            operation_service_id :operationServiceId,
            operation_date: date
        )
        operationBooking(request: operationBookingRequest)
        
    }
    
    func operationBooking(request: ConfirmOperationRequest) {
        let router = APIRouter.operationBooking(request)
        apiClient.postData(to: router.url, body: request, as: ConfirmOperationRequestResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:

                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self.status = .failure
                    
                }
            }, receiveValue: { response in
                print("Registration Response: \(response)")
                self.status = .success
            })
            .store(in: &cancellables)
        
    }
    

}

// MARK: - Private Helpers
extension OperationBookingViewModel {
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
extension OperationBookingViewModel {
    func navBack(){
        coordinator?.navigateBack()
    }
   func navToOperationConfirmed(){
        self.coordinator?.showOperationConfirmed(operationServiceId: self.operationServiceId ?? 0, hospitalData: self.hospitalData, date: self.date ?? "")

    }
}
