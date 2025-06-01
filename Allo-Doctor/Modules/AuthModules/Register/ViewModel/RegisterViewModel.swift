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
    var phoneSubject = CurrentValueSubject<String, Never>("")
    var genderSubject = CurrentValueSubject<String, Never>("")
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
extension RegisterViewModel{
    func createuser() {
        let registrationRequest = UserData(
            name: nameSubject.value,
            gender: "male",
            districtID: districtId.value,
            defaultLanguage: "en", age: ageSubject.value, phoneNumber: UserDefaultsManager.sharedInstance.getMobileNumber()
        )
        registerUser(request: registrationRequest)
        
    }
    
    func registerUser(request: UserData) {
        let router = APIRouter.registerUser
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
                self.handleSuccess(response)
                
            })
            .store(in: &cancellables)
        
    }
   }
extension RegisterViewModel{
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
    private func handleSuccess(_ login: RegisterResponse) {
        // First store all user data in UserDefaults
        if let token = login.data?.token {
            AuthManager.shared.setToken(token)
            print(token)
        }

        if let name = login.data?.name {
            UserDefaultsManager.sharedInstance.setUserName(userName: name)
  
        }
        func setUserId(UserId: Int?) {
            UserDefaults.standard.set(UserId, forKey: "User_Id")
        }
        
        func getUserId() -> Int? {
            return UserDefaults.standard.integer(forKey: "User_Id")
        }
       
        if let userId = login.data?.id {
            UserDefaultsManager.sharedInstance.setUserId(UserId: userId)
        }
        
        // Mark user as logged in
        UserDefaultsManager.sharedInstance.login()
        
        // Verify all required data is stored
        guard AuthManager.shared.hasToken() != nil,
              UserDefaultsManager.sharedInstance.getUserName() != nil,
              UserDefaultsManager.sharedInstance.getMobileNumber() != nil else {
            errorMessage = "Failed to save user data"
            return
        }
        
        // After ensuring all data is saved, navigate to tab bar
        DispatchQueue.main.async {
            self.coordinator?.showTabBar()
        }
    }
}
