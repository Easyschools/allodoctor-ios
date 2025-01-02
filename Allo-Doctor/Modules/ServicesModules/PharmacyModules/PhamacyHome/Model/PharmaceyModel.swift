//
//  PharmaceyModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/10/2024.
//

import Foundation

// MARK: - PharmacyResponse
struct PharmaciesResponse: Decodable {
    let data: [Pharmacy]
}
struct PharmacyResponse: Decodable {
    let data: Pharmacy
}
// MARK: - Pharmacy
struct Pharmacy: Decodable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let titleEn: String
    let titleAr: String
    let descriptionEn: String
    let descriptionAr: String
    let distance: Double?
    let address: String
    let cityId: Int?
    let districtId: Int
    let districtName: String
//    let district: District
    let latitude: String
    let longitude: String
    let to: String?
    let from: String?
    let pickup: Int
    let delivery: Int
    let phone: String?
    let url: String?
    let experience: String?
    let mainImage: String?
    let backgroundImage: String?
    let categories: [Category]
//    let reviews: [Review]
    
    enum CodingKeys: String, CodingKey {
        case id, address, latitude, longitude, to, from, pickup, delivery, phone, url, experience
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case distance
        case cityId = "city_id"
        case districtId = "district_id"
        case districtName = "district_name"
        case mainImage = "main_image"
        case backgroundImage = "background_image"
        case categories
    }
}

// MARK: - District
//struct District: Decodable {
//    let id: Int
//    let cityId: Int
//    let name: String
//    let nameAr: String
//    let nameEn: String
//    
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case cityId = "city_id"
//        case nameAr = "name_ar"
//        case nameEn = "name_en"
//    }
//}

// MARK: - Category
struct Category: Decodable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let mainImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case mainImage = "main_image"
    }
}

// MARK: - Review
struct Review: Decodable {
    // Add properties here when review data structure is provided
}
