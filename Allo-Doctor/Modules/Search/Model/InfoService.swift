//
//  InfoService.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 19/09/2024.
//

import Foundation

// MARK: - Main Data Model
struct HospitalData: Decodable {
    let data: Hospital
}

// MARK: - Hospital
struct Hospital: Decodable {
    let id: Int
    let nameAr: String
    let nameEn: String
    let name: String
    let slug: String
    let descriptionAr: String
    let description: String
    let descriptionEn: String
    let order: Int
    let image: String? // Null values should be optional
    let specialties: [Specialty]
    let doctors: [Doctor]

    // Coding Keys to map the JSON keys to custom variable names
    enum CodingKeys: String, CodingKey {
        case id, slug, order, image, specialties, doctors
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case name
        case descriptionAr = "description_ar"
        case description
        case descriptionEn = "description_en"
    }
}

// MARK: - Specialty
struct Specialty: Decodable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let name: String
    let descriptionEn: String
    let descriptionAr: String
    let description: String

    // Coding Keys for custom mapping
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
    }
}

// MARK: - Doctor
struct Doctor: Decodable {
    let id: Int
    let name: String
    let titleEn: String?
    let titleAr: String
    let title: String?
    let descriptionEn: String
    let descriptionAr: String
    let description: String
    let address: String
    let lat: Double?
    let long: Double?
    let rate: Double?
    let waitingTime: String?
    let price: String
    let priceAfterDiscount: String
    let experience: String
    let mainImage: String?

    // Coding Keys for custom mapping
    enum CodingKeys: String, CodingKey {
        case id, name, address, lat, long, rate, experience, price
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case title
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case description
        case waitingTime = "waitng_time"
        case priceAfterDiscount = "price_after_discount"
        case mainImage = "main_image"
    }
}
