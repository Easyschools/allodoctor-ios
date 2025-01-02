//
//  UserAdressSelectModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import Foundation

struct UserAddressResponse: Decodable {
    let data: [UserAddress]?
}

struct UserAddress: Decodable {
    let id: Int?
    let lat: String?
    let long: String?
    let address: String?
    let floor: Int?
    let appartmentNumber: Int?
    let user: UserInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case lat
        case long
        case address
        case floor
        case appartmentNumber = "appartment_number"
        case user
    }
}

struct UserInfo: Decodable {
    let id: Int?
    let name: String?
    let gender: String?
    let age: String?
    let phone: String?
    let active: Int?
    let otp: String?
    let otpExpiresAt: String?
    let areaOfResidence: String?
    let defaultLanguage: String?
    let defaultCountry: String?
    let image: String?
    let deletedAt: String?
    let createdAt: String?
    let updatedAt: String?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case gender
        case age
        case phone
        case active
        case otp
        case otpExpiresAt = "otp_expires_at"
        case areaOfResidence = "area_of_residence"
        case defaultLanguage = "default_language"
        case defaultCountry = "default_country"
        case image
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case email
    }
}
