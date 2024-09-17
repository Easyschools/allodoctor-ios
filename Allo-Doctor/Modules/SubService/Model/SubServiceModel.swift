//
//  SubServiceModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 15/09/2024.
//

import Foundation

// MARK: - SubServiceResponse
struct SubServiceResponse: Decodable {
    let data: [SubService]
//    let links: Links
//    let meta: Meta
}

// MARK: - SubService
struct SubService: Decodable {
    let id: Int
//    let nameAr: String
//    let nameEn: String
    let name: String
//    let slug: String
//    let descriptionAr: String?
//    let description: String?
//    let descriptionEn: String?
//    let order: Int
//    let image: String
//    let service: Service
}
struct Links: Decodable {
    let first: String
    let last: String
    let prev: String?
    let next: String?
}

// MARK: - Meta
struct Meta: Decodable {
    let currentPage: Int
    let from: Int
    let lastPage: Int
    let links: [MetaLink]
    let path: String
    let perPage: Int
    let to: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case links
        case path
        case perPage = "per_page"
        case to
        case total
    }
}

// MARK: - MetaLink
struct MetaLink: Decodable {
    let url: String?
    let label: String
    let active: Bool
}

