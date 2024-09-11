//
//  RegisterViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//

import Foundation
import Combine
struct UserRegistrationResponse: Codable {
    let success: Bool
    let message: String
}

class RegisterViewModel:ObservableObject {
    var nameSubject = CurrentValueSubject<String, Never>("")
    var ageSubject = CurrentValueSubject<String, Never>("")
    var cancellables = Set<AnyCancellable>()

    let networkLayer = NetworkLayer()
    private let apiClient: APIClient

     init(apiClient: APIClient = APIClient()) {
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
       }}
