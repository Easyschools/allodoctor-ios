//
//  ProfileEditModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/12/2024.
//

import Foundation

// Register response model, where data could be optional
struct ProfileEditResponse: Codable {
    let data:ProfileEditRequest?
}

// User data model
struct ProfileEditRequest: Codable {
    let id : Int
    let name: String?
    let districtID: Int?
    let age: String?
    let email:String?


    enum CodingKeys: String, CodingKey {
        case id
        case name
        case districtID = "district_id"
        case age
        case email

    }
}

// User registration response model
//struct UserRegistrationResponse: Codable {
//    let success: Bool
//    let message: String
//}
struct UserUpdateResponse: Decodable {
    let data: UserUpdatedData?
}

struct UserUpdatedData: Decodable {
    let id: Int?
    let name: String?
    let email: String?
    let gender: String?
    let phone: String?
    let district: District?
    let districtID: Int?
    let age: String?
    let defaultLanguage: String?
    let defaultCountry: String?
    let active: Int?
    let createdAt: String?
    let image: String?
    let medicalInsurance: [MedicalInsurance]?
    let role: [String]? // assuming role is an array of strings

    enum CodingKeys: String, CodingKey {
        case id, name, email, gender, phone, district
        case districtID = "district_id"
        case age
        case defaultLanguage = "default_language"
        case defaultCountry = "default_country"
        case active
        case createdAt = "created_at"
        case image
        case medicalInsurance = "medical_insurance"
        case role
    }
}



