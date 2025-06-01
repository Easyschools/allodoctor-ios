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
    
    // CodingKeys to map JSON keys to Swift property names
    private enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case serviceId = "service_id"
    }
}
