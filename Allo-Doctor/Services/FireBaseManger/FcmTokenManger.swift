//
//  FcmTokenManger.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/01/2025.
//

import FirebaseMessaging

class FCMTokenManager {
    static let shared = FCMTokenManager()
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "fcmToken"
    private let phoneKey = "userPhone"
    
    // API endpoint
    private let apiURL = "https://Backend.allo-doctor.com/api/auth/save-fcm-token"
    
    // Get the stored token and phone
    private var storedToken: String? {
        return userDefaults.string(forKey: tokenKey)
    }
    
    private var storedPhone: String? {
        return userDefaults.string(forKey: phoneKey)
    }
    
    // Save token and phone
    private func saveToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
    }
    
    func savePhone(_ phone: String) {
        userDefaults.set(phone, forKey: phoneKey)
    }
    
    // Handle token update with phone number
    func handleTokenUpdate(_ newToken: String, phoneNumber: String) {
        // Save the phone number
        savePhone(phoneNumber)
        
        let oldToken = storedToken
        
        // Determine if this is a new or existing token
        if let existingToken = oldToken {
            // Token exists - handle as token refresh
            sendTokenToServer(newToken: newToken, oldToken: existingToken, phoneNumber: phoneNumber)
        } else {
            // New token - handle as new registration
            sendTokenToServer(newToken: newToken, oldToken: nil, phoneNumber: phoneNumber)
        }
        
        // Save the new token
        saveToken(newToken)
    }
    
    // Send token and phone number to your server
    private func sendTokenToServer(newToken: String, oldToken: String?, phoneNumber: String) {
        // Prepare the request body
        let parameters: [String: Any] = [
            "fcm_token": newToken,
            "old_fcm_token": oldToken as Any,
            "phone": phoneNumber,
            "platform": "ios"
        ]
        
        // Create the request
        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add your authorization header if required
        // request.setValue("Bearer \(yourAuthToken)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error encoding parameters: \(error)")
            return
        }
        
        // Make the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending token to server: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                print("Token and phone number successfully sent to server")
            } else {
                print("Server returned status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
}
