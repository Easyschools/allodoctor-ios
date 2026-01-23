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
    let addressAr: String?
    let addressEn: String?
    let cityId: Int?
    let districtId: Int
    let districtName: String
    let district: District?
    let latitude: String
    let longitude: String
    let to: String?
    let from: String?
    let pickup: Int
    let deliveryTime: String?
    let delivery: String?
    let phone: String?
    let url: String?
    let experience: String?
    let mainImage: String?
    let backgroundImage: String?
    let categories: [Category]
    let avgRating: Double?
    let reviewsCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, latitude, longitude, to, from, pickup, phone, url, experience
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case addressEn = "address_en"
        case addressAr = "address_ar"
        case distance
        case delivery = "delivery_fees"
        case cityId = "city_id"
        case districtId = "district_id"
        case districtName = "district_name"
        case mainImage = "main_image"
        case backgroundImage = "background_image"
        case categories
        case district
        case avgRating = "avg_rating"
        case deliveryTime = "delivery_time"
        case reviewsCount = "reviews_count"
    }
    
    // Custom decoder to handle string/double conversion
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        nameEn = try container.decode(String.self, forKey: .nameEn)
        nameAr = try container.decode(String.self, forKey: .nameAr)
        titleEn = try container.decode(String.self, forKey: .titleEn)
        titleAr = try container.decode(String.self, forKey: .titleAr)
        descriptionEn = try container.decode(String.self, forKey: .descriptionEn)
        descriptionAr = try container.decode(String.self, forKey: .descriptionAr)
        distance = try container.decodeIfPresent(Double.self, forKey: .distance)
        addressAr = try container.decodeIfPresent(String.self, forKey: .addressAr)
        addressEn = try container.decodeIfPresent(String.self, forKey: .addressEn)
        cityId = try container.decodeIfPresent(Int.self, forKey: .cityId)
        districtId = try container.decode(Int.self, forKey: .districtId)
        districtName = try container.decode(String.self, forKey: .districtName)
        district = try container.decodeIfPresent(District.self, forKey: .district)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
        to = try container.decodeIfPresent(String.self, forKey: .to)
        from = try container.decodeIfPresent(String.self, forKey: .from)
        pickup = try container.decode(Int.self, forKey: .pickup)
        deliveryTime = try container.decodeIfPresent(String.self, forKey: .deliveryTime)
        delivery = try container.decodeIfPresent(String.self, forKey: .delivery)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        experience = try container.decodeIfPresent(String.self, forKey: .experience)
        mainImage = try container.decodeIfPresent(String.self, forKey: .mainImage)
        backgroundImage = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
        categories = try container.decode([Category].self, forKey: .categories)
        reviewsCount = try container.decodeIfPresent(Int.self, forKey: .reviewsCount)
        
        // Handle avg_rating as either String or Double
        if let ratingDouble = try? container.decodeIfPresent(Double.self, forKey: .avgRating) {
            avgRating = ratingDouble
        } else if let ratingString = try? container.decodeIfPresent(String.self, forKey: .avgRating) {
            avgRating = Double(ratingString)
        } else {
            avgRating = nil
        }
    }
}


struct District: Decodable {
    let id: Int?
    let cityId: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case cityId = "city_id"
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}

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
