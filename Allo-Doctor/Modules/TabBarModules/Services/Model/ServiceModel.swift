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

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
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
