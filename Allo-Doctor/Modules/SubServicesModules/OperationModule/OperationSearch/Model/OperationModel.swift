//
//  OperationModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/11/2024.
//

import Foundation
struct OperationsResponse: Decodable {
    let data: [Operation]?
    let links: Links?
    let meta: Meta?
}
extension OperationsResponse: PaginatedResponse {
    typealias Item = Operation
    
    // Computed property to get the next page URL
    var nextPageURL: URL? {
        guard let next = links?.next else { return nil }
        return URL(string: next)
    }
}

struct Operation: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let serviceId: Int?
    let infoServices: [OperationListInfoService]?

    // CodingKeys to map JSON keys to Swift property names
    private enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case serviceId = "service_id"
        case infoServices = "info_services"
    }
}

// MARK: - Models for info_services from /admin/operation/all response
struct OperationListInfoService: Decodable {
    let infoService: OperationListHospital?
    let operationInfo: OperationListOperationInfo?

    enum CodingKeys: String, CodingKey {
        case infoService = "info_service"
        case operationInfo = "operation_info"
    }
}

struct OperationListHospital: Decodable {
    let id: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?
    let descriptionAr: String?
    let descriptionEn: String?
    let avgRating: Double?
    let reviewsCount: Int?
    let image: String?
    let backgroundImage: String?
    let address: String?
    let lat: String?
    let long: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image, address, lat, long
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case avgRating = "avg_rating"
        case reviewsCount = "reviews_count"
        case backgroundImage = "background_image"
    }
}

struct OperationListOperationInfo: Decodable {
    let operationServiceId: Int?
    let price: String?
    let infoServiceId: Int?

    enum CodingKeys: String, CodingKey {
        case operationServiceId = "operation_service_id"
        case price
        case infoServiceId = "info_service_id"
    }
}
