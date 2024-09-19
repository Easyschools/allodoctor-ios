//
//  Cities.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 19/09/2024.
//

import Foundation

// MARK: - CityResponse
struct CityResponse: Decodable {
    let data: [City]

}

// MARK: - City
struct City: Decodable {
    let id: Int
    let country_id: Int
    let name: String
    let name_ar: String
    let name_en: String
}

