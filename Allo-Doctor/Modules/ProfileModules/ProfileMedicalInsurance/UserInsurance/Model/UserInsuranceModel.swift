//
//  UserInsuranceModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/12/2024.
//

import Foundation
struct LaravelResponse: Decodable {
    let data: MedicalInsurance?
    let message: String?
}
struct UserInsuranceModel:Codable{
    let medical_insurance_id:Int
    let id_number: String
    let age : String
}
struct InsuranceResponseData: Decodable {
    let medicalInsurance: MedicalInsurance?
    let user: User?
    let pivot: Pivot?

    enum CodingKeys: String, CodingKey {
        case medicalInsurance = "medical_insurance"
        case user
        case pivot
    }
}

// Medical Insurance
struct MedicalInsurance: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let phone: String?
    let mainImage: String?
    let backgroundImage: String?
    let titleEn: String?
    let titleAr: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case phone
        case mainImage = "main_image"
        case backgroundImage = "background_image"
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case email
    }
}

// User
struct User: Decodable {
    let id: Int?
    let name: String?
    let email: String?
}

// Pivot
struct Pivot: Decodable {
    let id: Int?
    let age: String?
    let idNumber: String?
    let photoOfMedicalCard: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case age
        case idNumber = "id_number"
        case photoOfMedicalCard = "photo_of_medical_card"
        case status
    }
}
