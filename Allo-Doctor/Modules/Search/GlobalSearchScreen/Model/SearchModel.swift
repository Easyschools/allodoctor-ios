//
//  InfoService.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 19/09/2024.
//

import Foundation

// Model for each speciality
struct AllSpeciality: Decodable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let name: String
    let descriptionEn: String
    let descriptionAr: String
    let description: String

    // Coding keys to map JSON keys to model properties
    private enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case description
    }
}

// Model for the response
struct AllSpecialityResponse: Decodable {
    let data: [AllSpeciality]
}

struct SearchResultResponseData: Decodable {
    let data: [SearchResult]
}

// MARK: - Clinic
struct SearchResult: Decodable {
    let id: Int
    let name: String
    let nameAr: String
    let nameEn: String
    let type: String
    let source: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, type
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case source = "Source"
    }
}
