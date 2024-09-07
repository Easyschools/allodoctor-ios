//
//  UserDefault.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/09/2024.
//

import Foundation

class UserDefaultsManager: UserDefaultProtocol{
    
    static let sharedInstance = UserDefaultsManager()
    
    private init() {
        
    }
    
//    func setToken(token: String?){
//        UserDefaults.standard.set(token, forKey: "token")
//    }
//
//    func getToken()-> String?{
//        return UserDefaults.standard.string(forKey: "token")
//    }
//
//    func setUserName(userName: String?){
//        UserDefaults.standard.set(userName, forKey: "User_Name")
//    }
//
//    func getUserName()-> String?{
//        return UserDefaults.standard.string(forKey: "User_Name")
//    }
    
    func checkingShowingOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: "isJustDownloaded")
    }
    
    func sawOnboarding() {
        UserDefaults.standard.set(true, forKey: "isJustDownloaded")
    }
    
    func presentOnboarding() {
        UserDefaults.standard.set(false, forKey: "isJustDownloaded")
    }
    
    func login() {
        UserDefaults.standard.set(true, forKey: "IsLoggedIn")
    }
    
    func logut() {
        UserDefaults.standard.set(false, forKey: "IsLoggedIn")
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "IsLoggedIn")
    }

}

