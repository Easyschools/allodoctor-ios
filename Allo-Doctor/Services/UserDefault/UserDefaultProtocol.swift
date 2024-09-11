//
//  UserdefaultProtocol.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/09/2024.
//

import Foundation

protocol UserDefaultProtocol {
    func checkingShowingOnboarding() -> Bool
    func sawOnboarding()
    func presentOnboarding()
    
    func isLoggedIn() -> Bool
    func login()
    func logout()
    func setMobileNumber(mobileNumber: String?)
    func getMobileNumber() -> String?
}
