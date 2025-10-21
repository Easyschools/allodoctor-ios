////
////  PhoneNumberViewModel.swift
////  Allo-Doctor
////
////  Created by Abdallah ismail on 21/09/2024.
////
//
//import Foundation
//enum isVerified:String{
//    case yes = "Phone already exists."
//    case no = "OTP sent via SMS"
//    case noData = "Data is empty."
//    case dataExists = "Data already exists."
//}
//
//class PhoneNumberViewModel{
//// MARK: - Private Vars
//    private var coordinator: HomeCoordinatorContact?
//    private var userDefaultsManager: UserDefaultProtocol
//    var mobileSubject = CurrentValueSubject<String, Never>("")
//    private let apiClient: APIClient
//    private var cancellables = Set<AnyCancellable>()
//// MARK: - Init
//    init(coordinator: HomeCoordinatorContact? = nil,apiClient: APIClient = APIClient(),userDefaultsManager: UserDefaultProtocol = UserDefaultsManager.sharedInstance) {
//        self.coordinator = coordinator
//        self.apiClient = apiClient
//        self.userDefaultsManager = userDefaultsManager
//    }
//    
//}
//// MARK: - UserDefault PhoneNumber SET
//extension PhoneNumberViewModel{
//    func postMobileNumber (){
//        print(mobileSubject.value)
//        if mobileSubject.value.first != "0"{
//            mobileSubject.value = "0" + mobileSubject.value
//        }
//        print(mobileSubject.value)
//
//       let phoneNumberRequest = PhoneNumberRequest(phone: mobileSubject.value)
//       userDefaultsManager.setMobileNumber(mobileNumber: mobileSubject.value)
//       postPhoneNumber(userPhone: phoneNumberRequest)
//        coordinator?.showOtpScreen()
//    }
//    
//}
//// MARK: - navigation TO OTP Screen
//extension PhoneNumberViewModel{
// func navToOtpScreen(){
//        coordinator?.showOtpScreen()
//    }
//}
//// MARK: - PostPhoneNumber for Verification
//extension PhoneNumberViewModel{
//    private func postPhoneNumber(userPhone:PhoneNumberRequest){
//        print("phone number send",userPhone)
//        let url = URL(string: "https://Backend.allo-doctor.com/api/auth/otp")!
//        apiClient.postData(to: url , body:userPhone, as: responseMessage.self)
//            .sink ( receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            },receiveValue: { [ weak self ] response in
//                print("response after send number\n")
//                dump(response.message)
//
//                self?.handleResponse(response)
//                
//            })
//            .store(in: &cancellables)
//      
//    }
//   private func handleResponse(_ response: responseMessage) {
//       
//       if response.message == isVerified.yes.rawValue && response.data == isVerified.dataExists.rawValue {
//            userDefaultsManager.setVerifiedNumber(isVerified: true )
//        }
//       else if response.message == isVerified.no.rawValue {
//            userDefaultsManager.setVerifiedNumber(isVerified: true )
//        }
//       else {
//            userDefaultsManager.setVerifiedNumber(isVerified: false )
//        }
//     
//       }
//}
import Foundation
import Combine

enum isVerified: String {
    case yes = "Phone already exists."
    case no = "OTP sent successfully."
    case noData = "Data is empty."
    case dataExists = "Data already exists."

//    case yes = "Phone already exists."
//    case no = "OTP sent via SMS"
//    case noData = "Data is empty."
//    case dataExists = "Data already exists."
}

class PhoneNumberViewModel {
    // MARK: - Private Vars
    private var coordinator: HomeCoordinatorContact?
    private var userDefaultsManager: UserDefaultProtocol
    var mobileSubject = CurrentValueSubject<String, Never>("")
    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    // MARK: - Init
    init(coordinator: HomeCoordinatorContact? = nil,
         apiClient: APIClient = APIClient(),
         userDefaultsManager: UserDefaultProtocol = UserDefaultsManager.sharedInstance) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.userDefaultsManager = userDefaultsManager
    }
}

// MARK: - UserDefault PhoneNumber SET
extension PhoneNumberViewModel {
    func postMobileNumber() {
        print(mobileSubject.value)
        if mobileSubject.value.first != "0" {
            mobileSubject.value = "0" + mobileSubject.value
        }
        print(mobileSubject.value)

        let phoneNumberRequest = PhoneNumberRequest(phone: mobileSubject.value)
        userDefaultsManager.setMobileNumber(mobileNumber: mobileSubject.value)
        postPhoneNumber(userPhone: phoneNumberRequest)
    }
}

// MARK: - Navigation TO OTP Screen
extension PhoneNumberViewModel {
    func navToOtpScreen() {
        coordinator?.showOtpScreen()
    }
}

// MARK: - PostPhoneNumber for Verification
extension PhoneNumberViewModel {
    private func postPhoneNumber(userPhone: PhoneNumberRequest) {
        print("phone number send", userPhone)
        guard let url = URL(string: "https://Backend.allo-doctor.com/api/auth/otp") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        apiClient.postData(to: url, body: userPhone, as: responseMessage.self, requiresAuth: false)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to send OTP: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                print("response after send number")
                dump(response.message)
                self?.handleResponse(response)
            })
            .store(in: &cancellables)
    }

    private func handleResponse(_ response: responseMessage) {
//        if response.message == isVerified.yes.rawValue && response.data == isVerified.dataExists.rawValue {
//            userDefaultsManager.setVerifiedNumber(isVerified: true)
//            coordinator?.showOtpScreen()
//        } else if response.message == isVerified.no.rawValue {
//            userDefaultsManager.setVerifiedNumber(isVerified: false)
//            coordinator?.showOtpScreen()
//        } else {
//            userDefaultsManager.setVerifiedNumber(isVerified: false)
//            errorMessage = response.message
//        }

        if response.message == isVerified.yes.rawValue && response.data == isVerified.dataExists.rawValue {
                    userDefaultsManager.setVerifiedNumber(isVerified: true )
            coordinator?.showOtpScreen()
                }
        else if response.message == isVerified.no.rawValue || (response.message == isVerified.yes.rawValue && response.data == isVerified.noData.rawValue){
                    userDefaultsManager.setVerifiedNumber(isVerified: false )
                   coordinator?.showOtpScreen()
                }
               else {
                    userDefaultsManager.setVerifiedNumber(isVerified: false )
                   errorMessage = response.message
                }
    }

    // MARK: - Resend OTP
    func resendOTP() {
        guard !mobileSubject.value.isEmpty else {
            errorMessage = "Phone number is required"
            return
        }

        var phoneNumber = mobileSubject.value
        if phoneNumber.first != "0" {
            phoneNumber = "0" + phoneNumber
        }

        let phoneNumberRequest = PhoneNumberRequest(phone: phoneNumber)
        resendOTPRequest(userPhone: phoneNumberRequest)
    }

    private func resendOTPRequest(userPhone: PhoneNumberRequest) {
        print("Resending OTP for phone:", userPhone)
        guard let url = URL(string: "https://Backend.allo-doctor.com/api/auth/resend-otp") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        apiClient.postData(to: url, body: userPhone, as: responseMessage.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to resend OTP: \(error.localizedDescription)"
                    print("Resend Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                print("Resend OTP response:")
                dump(response.message)
                self?.handleResendResponse(response)
            })
            .store(in: &cancellables)
    }

    private func handleResendResponse(_ response: responseMessage) {
        if response.message == "New OTP sent successfully." {
            // OTP sent successfully - no need to navigate, just inform user
            print("OTP resent successfully")
        } else {
            errorMessage = response.message
            print("Failed to resend OTP: \(response.message)")
        }
    }
}
