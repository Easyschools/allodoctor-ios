//
//  RegisterModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import Foundation

// Register response model, where data could be optional
struct RegisterResponse: Codable {
    let data: UserDataResponse?
}

// User data model
struct UserData: Codable {
    let name: String
    let gender: String
    let districtID: Int? // Make optional
    let defaultLanguage: String
    let age: String
    let phoneNumber: String?
   
    enum CodingKeys: String, CodingKey {
        case name
        case gender
        case districtID = "district_id"
        case defaultLanguage = "default_language"
        case age
        case phoneNumber = "phone_number"
       
    }
}

// User registration response model
struct UserRegistrationResponse: Codable {
    let success: Bool
    let message: String
}
struct UserDataResponse: Codable {
    let name: String
    let gender: String
    let districtID: Int? // Make optional
    let defaultLanguage: String
    let age: String
    let phoneNumber: String?
    let id : Int
    let token : String
    enum CodingKeys: String, CodingKey {
        case name
        case gender
        case districtID = "district_id"
        case defaultLanguage = "default_language"
        case age
        case phoneNumber = "phone_number"
        case token
        case id
    }
}
