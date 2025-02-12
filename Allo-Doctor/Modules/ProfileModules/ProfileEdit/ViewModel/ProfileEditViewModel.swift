//
//  ProfileEditViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/12/2024.
//

import Foundation
class ProfileEditViewModel{
    var coordinator: HomeCoordinatorContact?
    var nameSubject = CurrentValueSubject<String, Never>("")
    var emailSubject = CurrentValueSubject<String, Never>("")
    var numberSubject = CurrentValueSubject<String, Never>("")
    var ageSubject = CurrentValueSubject<String, Never>("")
    var districtId = CurrentValueSubject<Int, Never>(0)
    var cancellables = Set<AnyCancellable>()
    @Published var cities:[City] = []
    @Published var errorMessage: String?
    private let apiClient: APIClient
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
    }

}
extension ProfileEditViewModel{
    func updateUser() {
        let registrationRequest = ProfileEditRequest(
            id: UserDefaultsManager.sharedInstance.getUserId() ?? 0, name: nameSubject.value,
            
            districtID: districtId.value,
            age: ageSubject.value, phoneNumber: UserDefaultsManager.sharedInstance.getMobileNumber() ?? "" , email:emailSubject.value
        )
        registerUser(request: registrationRequest)
        print(registrationRequest)
    }
    
    func registerUser(request: ProfileEditRequest) {
        let router = APIRouter.updateUser
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
   }
extension ProfileEditViewModel{
    func getAllAreaOfResidence(){
        let router = APIRouter.fetchCities
        apiClient.fetchData(from:router.url, as: CityDataResponse.self)
            .sink(receiveCompletion: {completion in switch  completion {
            case.finished:
                break
            case .failure(let error):
                self.errorMessage  = "Failed to fetch Cities: \(error.localizedDescription)"
            }}, receiveValue: { citiesResponse in
                self.cities = citiesResponse.data ?? []
                
            }).store(in: &cancellables)
    }
  

}
extension ProfileEditViewModel{
    func navBack(){
        coordinator?.navigateBack()
    }
}
