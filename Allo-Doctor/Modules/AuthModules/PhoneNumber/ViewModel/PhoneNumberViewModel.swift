//
//  PhoneNumberViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//

import Foundation
enum isVerified:String{
    case yes = "Phone already exists."
    case no = "OTP sent successfully."
    case noData = "Data is empty."
    case dataExists = "Data already exists."
}
class PhoneNumberViewModel{
// MARK: - Private Vars
    private var coordinator: HomeCoordinatorContact?
    private var userDefaultsManager: UserDefaultProtocol
    var mobileSubject = CurrentValueSubject<String, Never>("")
    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
// MARK: - Init
    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient(),userDefaultsManager: UserDefaultProtocol = UserDefaultsManager.sharedInstance) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.userDefaultsManager = userDefaultsManager
    }
    
}
// MARK: - UserDefault PhoneNumber SET
extension PhoneNumberViewModel{
    func postMobileNumber (){
       let phoneNumberRequest = PhoneNumberRequest(phone: mobileSubject.value)
       userDefaultsManager.setMobileNumber(mobileNumber: mobileSubject.value)
       postPhoneNumber(userPhone: phoneNumberRequest)
        coordinator?.showOtpScreen()
    }
    
}
// MARK: - navigation TO OTP Screen
extension PhoneNumberViewModel{
 func navToOtpScreen(){
        coordinator?.showOtpScreen()
    }
}
// MARK: - PostPhoneNumber for Verification
extension PhoneNumberViewModel{
    private func postPhoneNumber(userPhone:PhoneNumberRequest){
        let url = URL(string: "https://allodoctor-backend.developnetwork.net/api/auth/otp")!
        apiClient.postData(to: url , body:userPhone, as: responseMessage.self)
            .sink ( receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            },receiveValue: { [ weak self ] response in
                self?.handleResponse(response)
                
            })
            .store(in: &cancellables)
      
    }
   private func handleResponse(_ response: responseMessage) {
       if response.message == isVerified.yes.rawValue && response.data == isVerified.dataExists.rawValue {
            userDefaultsManager.setVerifiedNumber(isVerified: true )
        }
       else if response.message == isVerified.no.rawValue {
            userDefaultsManager.setVerifiedNumber(isVerified: false )
        }
       else {
            userDefaultsManager.setVerifiedNumber(isVerified: false )
        }
     
       }
}
