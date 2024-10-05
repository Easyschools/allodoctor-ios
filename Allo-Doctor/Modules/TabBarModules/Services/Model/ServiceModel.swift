//
//  ServiceModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/09/2024.
//

import Foundation

struct Service: Codable {
    let id: Int
    let name: String
    let description: String?
    let price: Double?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case image
    }
}

struct ServiceResponse: Codable {
    let data: [Service]
    let currentPage: Int?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case data
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}
struct ServiceResponseData: Decodable {
    let data: ServiceData
}
struct ServiceData: Decodable {
    let id: Int
    let name_ar: String
    let name_en: String
    let name: String
    let slug: String
    let description_ar: String
    let description: String
    let description_en: String
    let order: Int
    let image: String
    let info_service: [ServiceInfo]

  
}
struct ServiceInfo: Decodable {
    let id: Int
    let name: String
    let name_ar: String
    let name_en: String
    let description_ar: String
    let description_en: String
    let district_id: Int
    let image: String
    let is_active: Int
    let address: String
    let lat: Double?
    let long: Double?
    let doctors_count: Int
    let specialties_count: Int
    let branches_count: Int

    // No need for custom coding keys since property names match the JSON keys
}
