//
//  RegisterViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//

import Foundation
class RegisterViewModel:ObservableObject {
    var coordinator: HomeCoordinatorContact?
    var nameSubject = CurrentValueSubject<String, Never>("")
    var ageSubject = CurrentValueSubject<String, Never>("")
    var cancellables = Set<AnyCancellable>()
    @Published var cities:[City] = []
    @Published var errorMessage: String?
    private let apiClient: APIClient
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }

}
extension RegisterViewModel{
    func createuser() {
        let registrationRequest = UserData(
            name: nameSubject.value,
            gender: "male",
            area_of_residence: "2",
            default_language: "en", age: "24"
        )
        registerUser(request: registrationRequest)
        coordinator?.showTabBar()
        
    }
    
    func registerUser(request: UserData) {
        let router = APIRouter.registerUser(request)
        apiClient.postData(to: router.url, body: request, as: RegisterResponse.self)
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
    func nav(){
      
    }}
extension RegisterViewModel{
    func getAllAreaOfResidence(){
        apiClient.fetchData(from: URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/city/all?is_paginate=30")!, as: CityResponse.self)
            .sink(receiveCompletion: {completion in switch  completion {
            case.finished:
                break
            case .failure(let error):
                self.errorMessage  = "Failed to fetch Cities: \(error.localizedDescription)"
            }}, receiveValue: { citiesResponse in
                self.cities = citiesResponse.data
                
            }).store(in: &cancellables)
    }

}
