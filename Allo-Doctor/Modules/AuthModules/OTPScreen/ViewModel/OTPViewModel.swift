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
                    UserDefaultsManager.sharedInstance.login()
                    self.coordinator?.showTabBar()
                } else {
                    self.coordinator?.showRegisterScreen()
                }
            }
        } else {
            print("Cannot verify OTP")
        }
    }
}
