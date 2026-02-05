//
//  EmergencyModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/12/2024.
//

import Foundation

// MARK: - Emergency Create Response
struct EmergencyResponse: Codable {
    let data: Emergency?
}

// MARK: - Emergency Get Details Response
struct EmergencyDetailsResponse: Codable {
    let data: EmergencyDetails?
}

// MARK: - Emergency Data Model (from create endpoint)
struct Emergency: Codable {
    let id: Int?
    let name: String
    let phone: String?
    let districtID: Int?
    let acceptTerms: Int
    let isME: Int
    let patientName: String
    let patientNumber: String
    let status: String?
    let user: User?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phone
        case districtID = "district_id"
        case acceptTerms = "accept_terms"
        case isME = "is_me"
        case patientName = "patient_name"
        case patientNumber = "patient_phone"
        case status
        case user
    }
    
    // User info nested in response
    struct User: Codable {
        let id: Int
        let name: String
        let email: String?
        let phone: String
        
        enum CodingKeys: String, CodingKey {
            case id, name, email, phone
        }
    }
}

// MARK: - Emergency Details Model (from get endpoint)
struct EmergencyDetails: Codable {
    let id: Int
    let name: String
    let district: District?
    let acceptTerms: Int
    let userId: Int
    let phone: String?
    let isME: Int
    let patientName: String
    let patientPhone: String
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case district
        case acceptTerms = "accept_terms"
        case userId = "user_id"
        case phone
        case isME = "is_me"
        case patientName = "patient_name"
        case patientPhone = "patient_phone"
        case status
    }
    
    // District info with localization
    struct District: Codable {
        let id: Int
        let cityId: Int
        let name: String
        let nameAr: String
        let nameEn: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case cityId = "city_id"
            case name
            case nameAr = "name_ar"
            case nameEn = "name_en"
        }
        
        // Get localized name based on current language
        var localizedName: String {
            let currentLanguage = UserDefaultsManager.sharedInstance.getLanguage()
            return currentLanguage == .ar ? nameAr : nameEn
        }
    }
    
    // Get localized address
    var localizedAddress: String {
        return district?.localizedName ?? ""
    }
}

// MARK: - Emergency Request Model
struct EmergencyRequest: Codable {
    let name: String
    let districtId: Int?
    let acceptTerms: Int
    let phone: String?
    let isME: Int
    let patientName: String
    let patientPhone: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case districtId = "district_id"
        case acceptTerms = "accept_terms"
        case phone
        case isME = "is_me"
        case patientName = "patient_name"
        case patientPhone = "patient_phone"
    }
}

// MARK: - Error Response
struct EmergencyErrorResponse: Codable {
    let message: String?
    let errors: [String: [String]]?
}
