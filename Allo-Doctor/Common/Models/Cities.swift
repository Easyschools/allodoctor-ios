//
//  Cities.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 19/09/2024.
//

import Foundation

// Root Model
struct CityDataResponse: Decodable {
    let data: [City]?
}

// City Model
struct City: Decodable {
    let id: Int?
    let countryID: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?
    let districts: [Districts]?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case name
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case districts
    }
}

// District Model
struct Districts: Decodable {
    let id: Int?
    let cityID: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?

    enum CodingKeys: String, CodingKey {
        case id
        case cityID = "city_id"
        case name
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}
