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
    let name: String
    let districtID: Int
    let age: String
    let phoneNumber: String
    let email:String


    enum CodingKeys: String, CodingKey {
        case id
        case name
        case districtID = "district_id"
        case age
        case phoneNumber = "phone_number"
        case email

    }
}

// User registration response model
//struct UserRegistrationResponse: Codable {
//    let success: Bool
//    let message: String
//}
