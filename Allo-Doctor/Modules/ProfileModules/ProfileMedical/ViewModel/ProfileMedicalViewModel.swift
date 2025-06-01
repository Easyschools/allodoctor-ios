//
//  ProfileMedicalViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/12/2024.
//

import Foundation
import UIKit
class ProfileMedicalViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    internal var medicalHistory = CurrentValueSubject<String, Never>("")
    internal var allergy = CurrentValueSubject<String, Never>("")
    internal var medication = CurrentValueSubject<String, Never>("")
    @Published var bookingStatus: BookingStatus?
    @Published var errorMessage: String?
    @Published var medicalData: MedicalData?
    private var apiClient = APIClient()
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
       self.coordinator = coordinator
       self.apiClient = apiClient
    }
}
extension ProfileMedicalViewModel{
    func confirmBooking(){
        let confirmOrderRequest = MedicalInfoBody(
            allergy: allergy.value, medication: medication.value,
            medicalHistory: medicalHistory.value
        )
        
        confirmBooking(request:confirmOrderRequest)
    }
    private func confirmBooking(request: MedicalInfoBody) {
        let router = APIRouter.medicalInfoPost
        apiClient.postData(to: router.url, body: request, as: MedicalInfoResponse.self)
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
    func fetchMedicalData() {
        let router = APIRouter.fetchMedicalData

        apiClient.fetchData(from: router.url, as: MedicalDataResponse.self)
            .sink(receiveCompletion: {  completion in
                switch completion {
                case .failure(let error):
                 print(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.medicalData = response.data
            }).store(in: &cancellables)
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
    
    private func handleResponse(_ response: MedicalInfoResponse) {
        // Handle successful response logic
        print("confirmed: \(response)")
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

extension ProfileMedicalViewModel {
    func navToHome(){
        coordinator?.navigateToRoot()
    }
    func navBack(){
        coordinator?.navigateBack()
    }
}
