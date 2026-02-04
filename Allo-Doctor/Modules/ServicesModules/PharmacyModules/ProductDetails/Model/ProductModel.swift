//
//  ProductModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/10/2024.
//

import Foundation
struct AddToCartResponse: Codable {
    let data: AddToCartData?
}

struct AddToCartData: Codable {
    let id: Int?
    let quantity: StringOrInt?
}

enum StringOrInt: Codable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            self = .int(intVal)
            return
        }
        if let strVal = try? container.decode(String.self) {
            self = .string(strVal)
            return
        }
        throw DecodingError.typeMismatch(StringOrInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Int"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let val): try container.encode(val)
        case .int(let val): try container.encode(val)
        }
    }
}

struct AddProductToCart: Codable {
    let pharmacy_id: String
    let category_id: String
    let medication_id: String
    let quantity: String
}
