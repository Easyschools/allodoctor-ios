//
//  EmergencyViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/12/2024.
//

import Foundation
import UIKit


class EmergencyViewModel: ObservableObject {
    var coordinator: HomeCoordinatorContact?
    var nameSubject = CurrentValueSubject<String, Never>(UserDefaultsManager.sharedInstance.getUserName() ?? "")
    var numberSubject = CurrentValueSubject<String, Never>(UserDefaultsManager.sharedInstance.getMobileNumber() ?? "")
    var districtId = CurrentValueSubject<Int, Never>(0)
    var cancellables = Set<AnyCancellable>()
    
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    @Published var bookingStatus: BookingStatus? // New published property
    
    private let apiClient: APIClient
    var infoServiceId: Int?

    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), infoServiceId: Int? = nil) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.infoServiceId = infoServiceId
    }
}

extension EmergencyViewModel {
    func createBooking() {
        let emergencyRequest = EmergencyRequest(
            name: nameSubject.value,
            districtId: districtId.value,
            acceptTerms: 1,
            phone: numberSubject.value,
            isME: 1,
            patientName: nameSubject.value,
            patientPhone: numberSubject.value,
            infoServiceId: infoServiceId
        )
        emergencyBooking(request: emergencyRequest)
    }

    func emergencyBooking(request: EmergencyRequest) {
        let router = APIRouter.bookEmergency(request)
        apiClient.postData(to: router.url, body: request, as: EmergencyResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Booking failed: \(error.localizedDescription)"
                    self.bookingStatus = .failure
                }
            }, receiveValue: { response in
                print("Registration Response: \(response)")
                self.bookingStatus = .success
            })
            .store(in: &cancellables)
    }
}

extension EmergencyViewModel {
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
extension EmergencyViewModel {
    func navToHome(){
        coordinator?.navigateToRoot()
    }
    func navBack(){
        coordinator?.navigateBack()
    }
    func  dissmissToHome(vc:UIViewController) {
        coordinator?.dismissPresnetiontabBarNav(vc)
    }
}
