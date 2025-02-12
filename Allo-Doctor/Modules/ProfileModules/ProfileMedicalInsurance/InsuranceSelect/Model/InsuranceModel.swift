//
//  InsuranceModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 31/12/2024.
//

import Foundation

// MARK: - UserInsuranceResponse
struct UserInsuranceResponse: Decodable {
    let data: [UserInsurance]?
}

// MARK: - UserInsurance
struct UserInsurance: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let phone: String?
    let mainImage: String?
    let email: String?
    let pivot: Pivot?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case phone
        case mainImage = "main_image"
        case email
        case pivot
    }
}

// MARK: - Pivot
//struct Pivot: Decodable {
//    let userId: Int?
//    let medicalInsuranceId: Int?
//    let id: Int?
//    let age: String?
//    let idNumber: String?
//    let photoOfMedicalCard: String?
//    let status: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case userId = "user_id"
//        case medicalInsuranceId = "medical_insurance_id"
//        case id
//        case age
//        case idNumber = "id_number"
//        case photoOfMedicalCard = "photo_of_medical_card"
//        case status
//    }
//}
