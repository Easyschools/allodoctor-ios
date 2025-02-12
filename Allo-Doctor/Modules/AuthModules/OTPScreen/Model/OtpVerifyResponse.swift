//
//  OtpVerifyResponse.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 28/09/2024.
//

import Foundation
struct OtpVerifyResponse:Codable{
    let otp:String 
    let phone : String
}
struct OtpMessageResponse: Decodable {
    let message: String
 
}

struct PhoneLoginRequest: Codable {
    let phone: String
}
struct LoginResponse: Codable {
    let id: Int?
    let name: String?
    let gender: String?
    let age: String?
    let phone: String?
    let active: Int?
    let otp: String?
    let otpExpiresAt: String?
    let defaultLanguage: String?
    let defaultCountry: String?
    let image: String?
    let deletedAt: String?
    let createdAt: String?
    let updatedAt: String?
    let email: String?
    let districtId: Int?
    let token: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case gender
        case age
        case phone
        case active
        case otp
        case otpExpiresAt = "otp_expires_at"
        case defaultLanguage = "default_language"
        case defaultCountry = "default_country"
        case image
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case email
        case districtId = "district_id"
        case token
    }
}
