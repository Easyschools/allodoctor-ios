//
//  OTPViewModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/09/2024.
//

import Foundation

class OTPViewModel {
    // MARK: - proprties
    weak var coordinator: HomeCoordinatorContact?
    @Published var otpInput: [String] = ["", "", "", ""]
    @Published var activeTextField: Int = 0
    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    private var userdefault: UserDefaultProtocol?
    @Published var errorMessage: String?
    // MARK: - Init
    init(coordinator: HomeCoordinatorContact? = nil, apiClient: APIClient = APIClient(), userDefaultsManager: UserDefaultProtocol = UserDefaultsManager.sharedInstance) {
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.userdefault = userDefaultsManager
    }
}

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
        let otpResponseRequest = OtpVerifyResponse(otp: otp, phone: phone)
        sendOTP(otpResponseRequest: otpResponseRequest)
    }
}

extension OTPViewModel {
    func sendOTP(otpResponseRequest: OtpVerifyResponse) {
        let url = URL(string: "https://allodoctor-backend.developnetwork.net/api/auth/verify-otp")!
        apiClient.postData(to: url, body: otpResponseRequest, as: OtpMessageResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] otpResponse in
                print("OTP Response:hereeeeee \(otpResponse)")
                self?.handleResponseMessageOutput(response: otpResponse)
            }).store(in: &cancellables)
    }

    func handleResponseMessageOutput(response: OtpMessageResponse) {
        print(OtpMessageResponse.self)
        if response.message == "OTP verified successfully." {
            DispatchQueue.main.async {
                if self.userdefault?.isVerifiedNumber() == true {
                    self.login()
                  
                } else {
                    self.coordinator?.showRegisterScreen()
                }
            }
        } else {
            print("Cannot verify OTP")
        }
    }
}
extension OTPViewModel{
    private func login(){
        let phone = UserDefaultsManager.sharedInstance.getMobileNumber() ?? ""
        let phoneLoginRequest = PhoneLoginRequest(phone: phone)
        NetworkService.shared.postData(endpoint:"auth/login", data: phoneLoginRequest) { result in
            switch result {
            case .success(let data):
             
                do {
                    let decoder = JSONDecoder()
                    let order = try decoder.decode(LoginResponse.self, from: data)
                    self.handleSuccess(order)
                } catch {
                    self.errorMessage = "Failed to parse server response."
                    print("Decoding error: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
//    private func handleSuccess(_ login: LoginResponse) {
//        UserDefaultsManager.sharedInstance.login()
//        print(login)
//        self.coordinator?.showTabBar()
//        AuthManager.shared.setToken(login.token ?? "")
//        userdefault?.setUserName(userName: login.name ?? "")
//        coordinator?.showTabBar()
//    }
    private func handleError(_ error: NetworkError) {
        switch error {
        case .serverError(let message):
            // Handle Laravel-style errors
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
            // No action needed for this case
            break
        }
    }
}
extension OTPViewModel {
    private func handleSuccess(_ login: LoginResponse) {
        // First store all user data in UserDefaults
        if let token = login.token {
            AuthManager.shared.setToken(token)
            print(token)
        }

        if let name = login.name {
            userdefault?.setUserName(userName: name)
        
        
        }
        func setUserId(UserId: Int?) {
            UserDefaults.standard.set(UserId, forKey: "User_Id")
        }
        
        func getUserId() -> Int? {
            return UserDefaults.standard.integer(forKey: "User_Id")
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
        
        // After ensuring all data is saved, navigate to tab bar
        DispatchQueue.main.async {
            self.coordinator?.showTabBar()
        }
    }
}
