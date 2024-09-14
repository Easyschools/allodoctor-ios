//
//  RegisterModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import Foundation

struct RegisterResponse: Codable {
    let data: UserData
}

struct UserData: Codable {
    let name: String
    let gender: String
    let area_of_residence: String
    let default_language: String
    let age: String
}
struct UserRegistrationResponse: Codable {
    let success: Bool
    let message: String
}
