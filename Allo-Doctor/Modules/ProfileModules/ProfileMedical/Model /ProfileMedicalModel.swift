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
struct deleteImageRequest:Codable {
    let deletedImageId:Int?
    let id :Int
    enum CodingKeys: String, CodingKey {
        case deletedImageId = "delete_image_id"
        case id
    }
}
struct MedicalData: Decodable {
    let id: Int?
    let allergy: String?
    let medication: String?
    let medicalHistory: String?
    let images : [Image]
    // Decoding the keys to match the JSON response
    enum CodingKeys: String, CodingKey {
        case id, allergy, medication,images
        case medicalHistory = "medical_history"
    }
}
struct Image: Decodable  {
    let id: Int?
    let image: String?
}
// Define the response wrapper which is optional
struct MedicalDataResponse: Decodable {
    let data: MedicalData?
}
