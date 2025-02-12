//
//  AuthManger.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 27/10/2024.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    private let tokenKey = "User_Token"
    /// Sets the user token in UserDefaults
    func setToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    /// Returns the authorization header from UserDefaults
    func getAuthorizationHeader() -> String? {
        guard let token = UserDefaults.standard.string(forKey: tokenKey) else { return nil }
        return "Bearer \(token)"
    }
    
    /// Clears the stored token in UserDefaults
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    /// Checks if a token exists in UserDefaults and returns it
    func hasToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
}

