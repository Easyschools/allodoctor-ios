//
//  ProfileEditViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/12/2024.
//

import Foundation
import Combine

class ProfileEditViewModel: ObservableObject {
    // MARK: - Dependencies
    var coordinator: HomeCoordinatorContact?
    private let apiClient: APIClient
    
    // MARK: - Input Subjects
    var nameSubject = CurrentValueSubject<String, Never>("")
    var emailSubject = CurrentValueSubject<String, Never>("")
    var numberSubject = CurrentValueSubject<String, Never>("")
    var ageSubject = CurrentValueSubject<String, Never>("")
    var districtId = CurrentValueSubject<Int, Never>(0)
    @Published private(set) var state: State = .idle
    
    // MARK: - Published Properties
    @Published var cities: [City] = []
    @Published var userData: UserUpdatedData?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient()) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        setupInitialData()
    }
    
    // MARK: - Private Methods
    private func setupInitialData() {
        getUserData()
        getAllAreaOfResidence()
    }
    
    private func createProfileEditRequest() -> ProfileEditRequest {
        return ProfileEditRequest(
            id: UserDefaultsManager.sharedInstance.getUserId() ?? 0,
            name: nameSubject.value.nilIfEmpty,
            districtID: districtId.value == 0 ? nil : districtId.value,
            age: ageSubject.value.nilIfEmpty,
            email: emailSubject.value.nilIfEmpty
        )
    }
    
}

// MARK: - User Update Operations
extension ProfileEditViewModel {
    func updateUser() {
        state = .loading
        let request = createProfileEditRequest()
        print("Update request: \(request)")
        executeUserUpdate(request: request)
    }
    
    private func executeUserUpdate(request: ProfileEditRequest) {
        let router = APIRouter.updateUser
        
        // Start loading
        self.state = .loading
        self.errorMessage = nil

        apiClient.postData(to: router.url, body: request, as: UserUpdateResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.state = .success
                case .failure(let error):
                    self.state = .error
                    print(error)
                    self.errorMessage = "Failed to update profile: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
             
                guard let data = response.data else {
                    self.state = .error
                    self.errorMessage = "No data received in response."
                    return
                }
                
                self.handleUserUpdateResponse(data)
            })
            .store(in: &cancellables)
    }

    
    private func handleUserUpdateResponse(_ response: UserUpdatedData) {
        UserDefaultsManager.sharedInstance.setUserName(userName: response.name)
       
    }

}

// MARK: - Data Fetching Operations
extension ProfileEditViewModel {
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
    
    func getUserData(){
           guard let userId = UserDefaultsManager.sharedInstance.getUserId() else { return }
           let router = APIRouter.getUser(userId:userId)
           apiClient.fetchData(from:router.url, as: UserUpdateResponse.self)
               .sink(receiveCompletion: {completion in switch  completion {
               case.finished:
                   break
               case .failure(let error):
                   self.errorMessage  = "Failed to fetch user data: \(error.localizedDescription)"
               }}, receiveValue: { userResponse in
                   self.userData = userResponse.data
                   
               }).store(in: &cancellables)
       }
    
    private func handleCitiesResponse(_ response: CityDataResponse) {
        isLoading = false
        cities = response.data ?? []
    }
    
    private func handleUserDataResponse(_ response: UserUpdateResponse) {
        isLoading = false
        userData = response.data
        populateFormFields()
    }
    
    private func populateFormFields() {
        guard let userData = userData else { return }
        
        nameSubject.send(userData.name ?? "")
        emailSubject.send(userData.email ?? "")
        numberSubject.send(userData.phone ?? "")
        ageSubject.send(userData.age ?? "")
        districtId.send(userData.districtID ?? 0)
    }
}

// MARK: - Navigation
extension ProfileEditViewModel {
    func navBack() {
        coordinator?.navigateBack()
    }
   

}

