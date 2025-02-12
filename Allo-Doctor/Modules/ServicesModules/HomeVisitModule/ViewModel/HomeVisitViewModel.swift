//
//  HomeVisitViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/11/2024.
//

import Foundation
class HomeVisitViewModel{
    var coordinator: HomeCoordinatorContact?
    private var cancellables = Set<AnyCancellable>()
    internal var name = CurrentValueSubject<String, Never>("")
    internal var age = CurrentValueSubject<String, Never>("")
    internal var phone = CurrentValueSubject<String, Never>("")
    internal var note = CurrentValueSubject<String, Never>("")
    internal var address = CurrentValueSubject<String, Never>("")
    internal var districtId = CurrentValueSubject<Int, Never>(0)
    @Published var errorMessage: String?
    @Published var cities: [City] = []
    @Published var bookingStatus: BookingStatus?
    private var apiClient = APIClient()
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
       self.coordinator = coordinator
       self.apiClient = apiClient
    }
    }
  extension HomeVisitViewModel{
    func confirmBooking(){
           let confirmOrderRequest = BookingHomeBody(
            name : name.value,
            phone : phone.value,
            address : address.value,
            district_id:districtId.value,
            accept_terms : 1,
            speciality_id:1
           )
        
        confirmBooking(request:confirmOrderRequest)
       }
    private func confirmBooking(request: BookingHomeBody) {
        let router = APIRouter.bookHomeVisit(request)
        apiClient.postData(to: router.url,body:request, as: BookingHomeBodyResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                   
                    break
                case .failure(let error):
                    print(error)
                    self.bookingStatus = .failure
                  return
                }
            }, receiveValue: { [weak self] response in
                self?.handleResponse(response)
                self?.bookingStatus = .success
               
            })
            .store(in: &cancellables)
    }

    private func handleResponse(_ response: BookingHomeBodyResponse) {
       
    }
      func navBack(){
          coordinator?.navigateBack()
      }
      func navToHome(){
          coordinator?.navigateToRoot()
      }
    }
extension HomeVisitViewModel {
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
