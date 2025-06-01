//
//  UserdefaultProtocol.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/09/2024.
//

import Foundation

protocol UserDefaultProtocol {
    // User Name
    func setUserName(userName: String?)
    func getUserName() -> String?
    // Onboarding
    func checkingShowingOnboarding() -> Bool
    func sawOnboarding()
    func presentOnboarding()
    func hasSeenOnboarding() -> Bool
    func setHasSeenOnboarding()

    // Authentication
    func isLoggedIn() -> Bool
    func login()
    func logout()

    // Mobile Number
    func setMobileNumber(mobileNumber: String?)
    func getMobileNumber() -> String?

    // Verified Number
    func isVerifiedNumber() -> Bool
    func setVerifiedNumber(isVerified: Bool)

    // Coordinates
    func setCoordinates(lat: String, long: String)
    func getCoordinates() -> (lat: String, long: String)?

    // Language
    func setLanguage(language: AppLanguage)
    func getLanguage() -> AppLanguage?
    func isLanguageSet() -> Bool 
    // userId
    func setUserId(UserId: Int?)
    func getUserId() -> Int?
}
