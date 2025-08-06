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
        deleteAllFiles()
            let keys = [
                "User_Name",
                "IsLoggedIn",
                "Mobile_Number",
                "IsVerifiedNumber",
                "User_Id",
                "Latitude",
                "Longitude",
                "selectedAreaName"
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
   
   
    
    func getSavedAreaName() -> String? {
        return UserDefaults.standard.string(forKey: "selectedAreaName")
    }
    func setArea(areaName: String) {
        UserDefaults.standard.set(areaName, forKey: "selectedAreaName")
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
    private func deleteAllFiles() {
        let fileManager = FileManager.default
        
        // Directories to clear
        let directories: [FileManager.SearchPathDirectory] = [.documentDirectory, .cachesDirectory, .applicationSupportDirectory]
        
        for directory in directories {
            if let dirPath = fileManager.urls(for: directory, in: .userDomainMask).first {
                do {
                    let filePaths = try fileManager.contentsOfDirectory(at: dirPath, includingPropertiesForKeys: nil)
                    for filePath in filePaths {
                        try fileManager.removeItem(at: filePath)
                    }
                } catch {
                    print("Error deleting files in \(directory): \(error.localizedDescription)")
                }
            }
        }
        
        // Clear temp directory separately
        let tempDirectory = NSTemporaryDirectory()
        do {
            let tempFiles = try fileManager.contentsOfDirectory(atPath: tempDirectory)
            for file in tempFiles {
                let filePath = (tempDirectory as NSString).appendingPathComponent(file)
                try fileManager.removeItem(atPath: filePath)
            }
        } catch {
            print("Error deleting temp files: \(error.localizedDescription)")
        }
    }

}
