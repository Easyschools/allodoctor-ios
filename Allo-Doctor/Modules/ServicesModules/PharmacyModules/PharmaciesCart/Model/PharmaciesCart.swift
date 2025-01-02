//
//  PharmaciesCart.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/10/2024.
//

import Foundation

struct CartResponse: Decodable {
    let data: [Cart]
}
struct Cart: Decodable {
    let pharmacyID: Int
    let name: String
    let image: String?
    let totalPrice: String
    let totalQuantity: Int
    let items: [CartItem]
    
    enum CodingKeys: String, CodingKey {
        case pharmacyID = "pharmacy_id"
        case name
        case image
        case totalPrice = "total_price"
        case totalQuantity = "total_quantity"
        case items
    }
}

// Model for items within each Cart
struct CartItem: Decodable {
    let id: Int
    let quantity: Int
    let medication: Medication
    let category: Category
    let pharmacy: PharmacyCart
    let medicationPharmacy: Int
    let user: UserCart
}

// Medication model
struct Medication: Decodable {
    let id: Int
    let name: String
    let price: String
    let priceAfterDiscount: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, price
        case priceAfterDiscount = "price_after_discount"
        case image
    }
}

// Category model
struct CategoryCart: Decodable {
    let id: Int
    let name: String
}

// Pharmacy model
struct PharmacyCart: Decodable {
    let id: Int
    let name: String
}

// User model
struct UserCart: Decodable {
    let id: Int
    let name: String
}
