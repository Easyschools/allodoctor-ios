//
//  EmergencgyModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/12/2024.
//

import Foundation
struct EmergencgyResponse: Codable {
    let data: Emergencgy?
}

// User data model
struct  Emergencgy: Codable {
    let name: String
    let phone: String?
    let districtID: Int? // Make optional
    let acceptTerms : Int
    let isME :Int
    let patientName :String
    let patientNumber :String
    enum CodingKeys: String, CodingKey {
        case name
        case districtID = "district_id"
        case acceptTerms = "accept_terms"
        case phone = "phone"
        case isME = "is_me"
        case patientName = "patient_name"
        case patientNumber = "patient_phone"
    }
}

// User registration response model
struct EmergencgyErrorResponse: Codable {
    
}
