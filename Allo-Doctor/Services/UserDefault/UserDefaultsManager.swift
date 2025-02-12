//
//  UserDefault.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/09/2024.
//

import Foundation


class UserDefaultsManager: UserDefaultProtocol {


  
    
    static let sharedInstance = UserDefaultsManager()
    
    private init() {}
    func resetAllData() {
            let keys = [
                "User_Name",
                "IsLoggedIn",
                "Mobile_Number",
                "IsVerifiedNumber",
                "User_Id",
                "Latitude",
                "Longitude"
            ]
            
            for key in keys {
                UserDefaults.standard.removeObject(forKey: key)
            }
            UserDefaults.standard.synchronize() // Ensure changes are saved
        }
    // MARK: - User Name
    func setUserName(userName: String?) {
        UserDefaults.standard.set(userName, forKey: "User_Name")
    }
    
    // MARK: - Onboarding
    func checkingShowingOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: "isJustDownloaded")
    }
    func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: "User_Name")
    }
    
    func sawOnboarding() {
        UserDefaults.standard.set(true, forKey: "isJustDownloaded")
    }
    
    func presentOnboarding() {
        UserDefaults.standard.set(false, forKey: "isJustDownloaded")
    }
    
    func hasSeenOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    }
    
    func setHasSeenOnboarding() {
        UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
    }

    // MARK: - Authentication
    func login() {
        UserDefaults.standard.set(true, forKey: "IsLoggedIn")
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "IsLoggedIn")
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "IsLoggedIn")
    }
    
    // MARK: - Mobile Number
    func setMobileNumber(mobileNumber: String?) {
        UserDefaults.standard.set(mobileNumber, forKey: "Mobile_Number")
    }
    
    func getMobileNumber() -> String? {
        return UserDefaults.standard.string(forKey: "Mobile_Number")
    }
    
    // MARK: - Verified Number
    func isVerifiedNumber() -> Bool {
        return UserDefaults.standard.bool(forKey: "IsVerifiedNumber")
    }
    
    func setVerifiedNumber(isVerified: Bool) {
        UserDefaults.standard.set(isVerified, forKey: "IsVerifiedNumber")
    }
    func setUserId(UserId: Int?) {
        UserDefaults.standard.set(UserId, forKey: "User_Id")
    }
    
    func getUserId() -> Int? {
        return UserDefaults.standard.integer(forKey: "User_Id")
    }
    
    // MARK: - Coordinates
    func setCoordinates(lat: String, long: String) {
        UserDefaults.standard.set(lat, forKey: "Latitude")
        UserDefaults.standard.set(long, forKey: "Longitude")
    }
    
    func getCoordinates() -> (lat: String, long: String)? {
        guard let lat = UserDefaults.standard.value(forKey: "Latitude") as? String,
              let long = UserDefaults.standard.value(forKey: "Longitude") as? String else {
            return nil
        }
        return (lat, long)
    }

    // MARK: - Language
    func setLanguage(language: AppLanguage) {
           UserDefaults.standard.set(language.rawValue, forKey:"AppLanguage")
       }
       
       func getLanguage() -> AppLanguage? {
           guard let languageString = UserDefaults.standard.string(forKey:"AppLanguage") else {
               return nil
           }
           return AppLanguage(rawValue: languageString)
       }
       
       func isLanguageSet() -> Bool {
           return UserDefaults.standard.string(forKey: "AppLanguage") != nil
       }
}
