//
//  OTPViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//

import Foundation
//
//class OTPViewModel {
//    // MARK: - proprties
//    weak var coordinator: HomeCoordinatorContact?
//    @Published var otpInput: [String] = ["", "", "", ""]
//    @Published var activeTextField: Int = 0
//    private let apiClient: APIClient
//    private var cancellables = Set<AnyCancellable>()
//    private var userdefault: UserDefaultProtocol?
//    @Published var errorMessage: String?
//    // MARK: - Init
//    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), userDefaultsManager: UserDefaultProtocol = UserDefaultsManager.sharedInstance) {
//        self.coordinator = coordinator
//        self.apiClient = apiClient
//        self.userdefault = userDefaultsManager
//    }
//}
//
//extension OTPViewModel {
//    func handleInput(for index: Int, with string: String) {
//        guard string.count <= 1 else { return }
//        
//        if !string.isEmpty {
//            otpInput[index] = string
//            // Move to the next text field
//            if index < otpInput.count - 1 {
//                activeTextField = index + 1
//            } else {
//                activeTextField = index
//            }
//        } else {
//            // Handle backspace
//            otpInput[index] = ""
//            if index > 0 {
//                activeTextField = index - 1
//            }
//        }
//    }
//
//    var combinedOTP: String {
//        otpInput.joined()
//    }
//
//    var isOTPComplete: Bool {
//        otpInput.allSatisfy { !$0.isEmpty }
//    }
//
//    func navtoRegisterScreen() {
//        coordinator?.showRegisterScreen()
//    }
//
//    func checkOtp() {
//        let otp = self.otpInput.reduce("") { $0 + $1 }
//        let phone = UserDefaultsManager.sharedInstance.getMobileNumber() ?? ""
//        print(phone)
//        let otpResponseRequest = OtpVerifyResponse(otp: otp, phone: phone)
//        sendOTP(otpResponseRequest: otpResponseRequest)
//    }
//}
//
//extension OTPViewModel {
//    func sendOTP(otpResponseRequest: OtpVerifyResponse) {
//        let url = URL(string: "https://Backend.allo-doctor.com/api/auth/verify-otp")!
//        apiClient.postData(to: url, body: otpResponseRequest, as: OtpMessageResponse.self)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }, receiveValue: { [weak self] otpResponse in
//                print("OTP Response:hereeeeee \(otpResponse)")
//                self?.handleResponseMessageOutput(response: otpResponse)
//            }).store(in: &cancellables)
//    }
//
//    func handleResponseMessageOutput(response: OtpMessageResponse) {
//        print(response.message)
//        if response.message == "OTP verified successfully" {
//            DispatchQueue.main.async {
//                if self.userdefault?.isVerifiedNumber() == true {
//                    self.login()
//                  
//                } else {
//                    self.coordinator?.showRegisterScreen()
//                }
//            }
//        } else {
//            print("Cannot verify OTP")
//        }
//    }
//}
//extension OTPViewModel{
//    private func login(){
//        let phone = UserDefaultsManager.sharedInstance.getMobileNumber() ?? ""
//        let phoneLoginRequest = PhoneLoginRequest(phone: phone)
//        NetworkService.shared.postData(endpoint:"auth/login", data: phoneLoginRequest) { result in
//            switch result {
//            case .success(let data):
//             
//                do {
//                    let decoder = JSONDecoder()
//                    let order = try decoder.decode(LoginResponse.self, from: data)
//                    self.handleSuccess(order)
//                } catch {
//                    self.errorMessage = "Failed to parse server response."
//                    print("Decoding error: \(error.localizedDescription)")
//                }
//                
//            case .failure(let error):
//                self.handleError(error)
//            }
//        }
//    }
////    private func handleSuccess(_ login: LoginResponse) {
////        UserDefaultsManager.sharedInstance.login()
////        print(login)
////        self.coordinator?.showTabBar()
////        AuthManager.shared.setToken(login.token ?? "")
////        userdefault?.setUserName(userName: login.name ?? "")
////        coordinator?.showTabBar()
////    }
//    private func handleError(_ error: NetworkError) {
//        switch error {
//        case .serverError(let message):
//            // Handle Laravel-style errors
//            errorMessage = message
//            print("Server error: \(message)")
//            
//        case .unauthorized:
//            errorMessage = "Unauthorized: Please log in again."
//            print("Unauthorized access.")
//            
//        case .invalidData:
//            errorMessage = "Failed to parse server response."
//            print("Invalid data received from server.")
//            
//        case .networkError(let message):
//            errorMessage = "Network error: \(message)"
//            print("Network error: \(message)")
//            
//        case .invalidResponse:
//            errorMessage = "Unexpected server response."
//            print("Invalid response from server.")
//            
//        case .invalidImage:
//            // No action needed for this case
//            break
//        }
//    }
//}
//extension OTPViewModel {
//    private func handleSuccess(_ login: LoginResponse) {
//        // First store all user data in UserDefaults
//        if let token = login.token {
//            AuthManager.shared.setToken(token)
//            print(token)
//        }
//
//        if let name = login.name {
//            userdefault?.setUserName(userName: name)
//        
//        
//        }
//        func setUserId(UserId: Int?) {
//            UserDefaults.standard.set(UserId, forKey: "User_Id")
//        }
//        
//        func getUserId() -> Int? {
//            return UserDefaults.standard.integer(forKey: "User_Id")
//        }
//        if let phone = login.phone {
//            userdefault?.setMobileNumber(mobileNumber: phone)
//        }
//        if let userId = login.id {
//            userdefault?.setUserId(UserId: userId)
//        }
//        
//        // Mark user as logged in
//        UserDefaultsManager.sharedInstance.login()
//        
//        // Verify all required data is stored
//        guard AuthManager.shared.hasToken() != nil,
//              userdefault?.getUserName() != nil,
//              userdefault?.getMobileNumber() != nil else {
//            errorMessage = "Failed to save user data"
//            return
//        }
//        
//        // After ensuring all data is saved, navigate to tab bar
//        DispatchQueue.main.async {
//            self.coordinator?.showTabBar()
//        }
//    }
//}

import Foundation
import Combine

class OTPViewModel {
    // MARK: - Properties
    weak var coordinator: HomeCoordinatorContact?
    @Published var otpInput: [String] = ["", "", "", ""]
    @Published var activeTextField: Int = 0
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isLoading: Bool = false

    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    private var userdefault: UserDefaultProtocol?

    // MARK: - Init
    init(coordinator: HomeCoordinatorContact? = nil,
         apiClient: APIClient = APIClient(),
         userDefaultsManager: UserDefaultProtocol = UserDefaultsManager.sharedInstance) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.userdefault = userDefaultsManager
    }
}

// MARK: - Input Handling
extension OTPViewModel {
    func handleInput(for index: Int, with string: String) {
        guard string.count <= 1 else { return }

        if !string.isEmpty {
            otpInput[index] = string
            // Move to the next text field
            if index < otpInput.count - 1 {
                activeTextField = index + 1
            } else {
                activeTextField = index
            }
        } else {
            // Handle backspace
            otpInput[index] = ""
            if index > 0 {
                activeTextField = index - 1
            }
        }
    }

    var combinedOTP: String {
        otpInput.joined()
    }

    var isOTPComplete: Bool {
        otpInput.allSatisfy { !$0.isEmpty }
    }

    func navtoRegisterScreen() {
        coordinator?.showRegisterScreen()
    }

    func checkOtp() {
        let otp = self.otpInput.reduce("") { $0 + $1 }
        let phone = UserDefaultsManager.sharedInstance.getMobileNumber() ?? ""
        print("Verifying OTP for phone: \(phone)")
        let otpResponseRequest = OtpVerifyResponse(otp: otp, phone: phone)
        sendOTP(otpResponseRequest: otpResponseRequest)
    }
}

// MARK: - API Calls
extension OTPViewModel {
    func sendOTP(otpResponseRequest: OtpVerifyResponse) {
        guard let url = URL(string: "https://Backend.allo-doctor.com/api/auth/verify-otp") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        // Create custom URLRequest without authorization header for OTP verification
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(otpResponseRequest)

        print("Verifying OTP request:")
        dump(request)

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Verification failed: \(error.localizedDescription)"
                    print("OTP Error: \(error)")
                }
            }, receiveValue: { [weak self] output in
                // Log response
                if let responseString = String(data: output.data, encoding: .utf8) {
                    print("OTP Verification Response: \(responseString)")
                    self?.handleResponseMessageOutput(response: OtpMessageResponse(message: responseString, user: nil))
                }

                if let httpResponse = output.response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) {
                    if let otpResponse = try? JSONDecoder().decode(OtpMessageResponse.self, from: output.data) {
                        self?.handleResponseMessageOutput(response: otpResponse)
                    } else {
                        self?.errorMessage = "Failed to parse response"
                    }
                } else {
                    // Handle error response
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: output.data) {
                        self?.errorMessage = errorResponse.message
                    } else if let responseString = String(data: output.data, encoding: .utf8),
                              let jsonData = responseString.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                              let message = json["message"] as? String {
                        self?.errorMessage = message
                    } else {
                        self?.errorMessage = "Invalid or expired OTP"
                    }
                }
            })
            .store(in: &cancellables)
    }

//    func handleResponseMessageOutput(response: OtpMessageResponse) {
//        print("Response message: \(response.message)")
//        if response.message == "OTP verified successfully" {
//
//            if response.user?.name != nil {
//                self.userdefault?.setVerifiedNumber(isVerified: true)
//                self.login()
//            }
//                //else {
////                self.userdefault?.setVerifiedNumber(isVerified: false)
////                self.coordinator?.showRegisterScreen()
////            }
//
////            if self.userdefault?.isVerifiedNumber() == true {
////                self.login()
////            } else {
////                self.coordinator?.showRegisterScreen()
////            }
//        }else if response.message == "User not found"{
//            self.userdefault?.setVerifiedNumber(isVerified: false)
//            self.coordinator?.showRegisterScreen()
//        }
//        else {
//            //"User not found"
//            self.userdefault?.setVerifiedNumber(isVerified: false)
//            errorMessage = response.message
//            print("Cannot verify OTP: \(response.message)")
//        }
//    }

    func handleResponseMessageOutput(response: OtpMessageResponse) {
        print("Response message: \(response.message)")

        // Parse the nested JSON message
        let actualMessage = parseNestedMessage(response.message)
        print("Parsed message: \(actualMessage)")

        if actualMessage == "OTP verified successfully" {
//            if response.user?.name != nil {
            errorMessage = nil
                self.userdefault?.setVerifiedNumber(isVerified: true)
                self.login()
//            }
        } else if actualMessage == "User not found" {
            self.userdefault?.setVerifiedNumber(isVerified: false)
            self.coordinator?.showRegisterScreen()
        } else {
            self.userdefault?.setVerifiedNumber(isVerified: false)
            errorMessage = actualMessage
            print("Cannot verify OTP: \(actualMessage)")
        }
    }

    // Helper function to parse nested JSON
    private func parseNestedMessage(_ jsonString: String) -> String {
        guard let data = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
              let message = json["message"] else {
            return jsonString // Return original if parsing fails
        }
        return message
    }
    // MARK: - Resend OTP
    func resendOTP() {
        guard let phone = UserDefaultsManager.sharedInstance.getMobileNumber() else {
            errorMessage = "Phone number not found"
            return
        }

        guard let url = URL(string: "https://Backend.allo-doctor.com/api/auth/resend-otp") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        let phoneRequest = PhoneNumberRequest(phone: phone)

        // Create custom URLRequest without authorization header
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(phoneRequest)

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Try to extract error message from response
                    print("Resend OTP Error: \(error)")
                    self?.errorMessage = "Failed to resend OTP. Please try again."
                }
            }, receiveValue: { [weak self] output in
                // Try to decode as success response
                if let httpResponse = output.response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) {
                    if let response = try? JSONDecoder().decode(responseMessage.self, from: output.data) {
                        self?.handleResendResponse(response)
                    } else {
                        self?.successMessage = "OTP sent successfully"
                        self?.clearOTPInputs()
                    }
                } else {
                    // Handle error response
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: output.data) {
                        self?.errorMessage = errorResponse.message
                    } else if let responseString = String(data: output.data, encoding: .utf8) {
                        // Try to extract message from JSON string
                        if let jsonData = responseString.data(using: .utf8),
                           let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                           let message = json["message"] as? String {
                            self?.errorMessage = message
                        } else {
                            self?.errorMessage = "Failed to resend OTP"
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }

    private func handleResendResponse(_ response: responseMessage) {
        if response.message == "New OTP sent successfully." {
            successMessage = "New OTP sent successfully"
            clearOTPInputs()
            print("OTP resent successfully")
        } else {
            errorMessage = response.message
            print("Failed to resend OTP: \(response.message)")
        }
    }

    private func clearOTPInputs() {
        otpInput = ["", "", "", ""]
        activeTextField = 0
    }
}

// MARK: - Login
extension OTPViewModel {
    private func login() {
        guard let phone = UserDefaultsManager.sharedInstance.getMobileNumber() else {
            errorMessage = "Phone number not found"
            return
        }

        isLoading = true
        let phoneLoginRequest = PhoneLoginRequest(phone: phone)

        NetworkService.shared.postData(endpoint: "auth/login", data: phoneLoginRequest) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                        self?.handleSuccess(loginResponse)
                    } catch {
                        self?.errorMessage = "Failed to parse server response."
                        print("Decoding error: \(error.localizedDescription)")
                    }

                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }

    private func handleSuccess(_ login: LoginResponse) {
        // Store all user data in UserDefaults
        if let token = login.token {
            AuthManager.shared.setToken(token)
            print("Token stored successfully")
        }

        if let name = login.name {
            userdefault?.setUserName(userName: name)
        }

        if let phone = login.phone {
            userdefault?.setMobileNumber(mobileNumber: phone)
        }

        if let userId = login.id {
            userdefault?.setUserId(UserId: userId)
        }

        // Mark user as logged in
        UserDefaultsManager.sharedInstance.login()

        // Verify all required data is stored
        guard AuthManager.shared.hasToken() != nil,
              userdefault?.getUserName() != nil,
              userdefault?.getMobileNumber() != nil else {
            errorMessage = "Failed to save user data"
            return
        }

        // Navigate to tab bar
        coordinator?.showTabBar()
    }

    private func handleError(_ error: NetworkError) {
        switch error {
        case .serverError(let message):
            errorMessage = message
            print("Server error: \(message)")

        case .unauthorized:
            errorMessage = "Unauthorized: Please log in again."
            print("Unauthorized access.")

        case .invalidData:
            errorMessage = "Failed to parse server response."
            print("Invalid data received from server.")

        case .networkError(let message):
            errorMessage = "Network error: \(message)"
            print("Network error: \(message)")

        case .invalidResponse:
            errorMessage = "Unexpected server response."
            print("Invalid response from server.")

        case .invalidImage:
            break
        }
    }
}
