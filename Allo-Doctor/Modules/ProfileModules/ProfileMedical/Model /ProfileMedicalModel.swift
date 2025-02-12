//
//  ProfileMedicalModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/12/2024.
//

import Foundation


struct MedicalInfoResponse: Codable {
    var message: String?
    var data: MedicalInfoData?
}

struct MedicalInfoData: Codable {
    var id: Int?
    var allergy: String?
    var medication: String?
    var medicalHistory: String?
   
    
    enum CodingKeys: String, CodingKey {
        case id, allergy, medication
        case medicalHistory = "medical_history"
    }
}
struct MedicalInfoBody:Codable {
    let allergy:String?
    let medication:String?
    let medicalHistory:String?
    enum CodingKeys: String, CodingKey {
        case allergy, medication
        case medicalHistory = "medical_history"
    }
}
struct MedicalData: Decodable {
    let id: Int?
    let allergy: String?
    let medication: String?
    let medicalHistory: String?
    
    // Decoding the keys to match the JSON response
    enum CodingKeys: String, CodingKey {
        case id, allergy, medication
        case medicalHistory = "medical_history"
    }
}

// Define the response wrapper which is optional
struct MedicalDataResponse: Decodable {
    let data: MedicalData?
}
