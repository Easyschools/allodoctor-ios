//
//  HomeVisitViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/12/2024.
//

import Foundation
import UIKit
class HomeNursingViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    internal var name = CurrentValueSubject<String, Never>(UserDefaultsManager.sharedInstance.getUserName() ?? "")
    internal var age = CurrentValueSubject<String, Never>("")
    internal var phone = CurrentValueSubject<String, Never>(UserDefaultsManager.sharedInstance.getMobileNumber() ?? "")
    internal var note = CurrentValueSubject<String, Never>("")
    internal var address = CurrentValueSubject<String, Never>("")
    internal var districtId = CurrentValueSubject<Int, Never>(0)
    @Published var bookingStatus: BookingStatus?
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    private var apiClient = APIClient()
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
       self.coordinator = coordinator
       self.apiClient = apiClient
    }
}
extension HomeNursingViewModel{
    func confirmBooking(){
        let confirmOrderRequest = BookingHomeNursingBody(
            name :name.value,
            age :age.value, phone :phone.value,
            address:address.value, district_id: districtId.value,
            notes:note.value
        )
        
        confirmBooking(request:confirmOrderRequest)
    }
    private func confirmBooking(request: BookingHomeNursingBody) {
        let router = APIRouter.bookHomeNursing(request)
        apiClient.postData(to: router.url, body: request, as: BookingHomeNursingBodyResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                     print(error)
                    self?.bookingStatus = .failure
                }
            } receiveValue: { [weak self] response in
                self?.handleResponse(response)
                self?.bookingStatus = .success
            }
            .store(in: &cancellables)

    }
    
    private func handleError(message: String, errors: [String: [String]]? = nil) {
        var fullMessage = message
        if let errors = errors {
            let detailedErrors = errors.map { "\($0.key): \($0.value.joined(separator: ", "))" }
            fullMessage += "\n\n" + detailedErrors.joined(separator: "\n")
        }
        
        // Display the error to the user, e.g., using an alert
        showAlert(title: "Error", message: fullMessage)
    }
    
    private func handleResponse(_ response: BookingHomeNursingBodyResponse) {
        // Handle successful response logic
        print("Booking confirmed: \(response)")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }

    enum NetworkError: LocalizedError {
        case serverError(message: String, errors: [String: [String]])
        var errorDescription: String? {
            switch self {
            case .serverError(let message, _):
                return message
            }
        }
    }
    }
extension HomeNursingViewModel {
    func getAllAreaOfResidence() {
        let router = APIRouter.fetchCities
        apiClient.fetchData(from: router.url, as: CityDataResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to fetch Cities: \(error.localizedDescription)"
                }
            }, receiveValue: { citiesResponse in
                self.cities = citiesResponse.data ?? []
            })
            .store(in: &cancellables)
    }
}
extension HomeNursingViewModel {
    func navToHome(){
        coordinator?.navigateToRoot()
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}
