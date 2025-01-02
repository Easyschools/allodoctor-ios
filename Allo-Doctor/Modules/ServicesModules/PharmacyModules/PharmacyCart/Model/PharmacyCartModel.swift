//
//  PharmacyCartModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/10/2024.
//

import Foundation

struct PharmacyCartResponse: Decodable {
    let data: [PharmacyCartData]
}

struct PharmacyCartData: Decodable {
    let pharmacyId: Int
    let name: String
    let image: String?
    var totalPrice: String
    var totalQuantity: Int
    var items: [PharmacyCartItem]
    
    enum CodingKeys: String, CodingKey {
        case pharmacyId = "pharmacy_id"
        case name
        case image
        case totalPrice = "total_price"
        case totalQuantity = "total_quantity"
        case items
    }
}

struct PharmacyCartItem: Decodable {
    let id: Int
    var quantity: Int
    let medication: PhamracyCartMedication?  // Made optional
    let category: PhamracyCartCategory
    let pharmacy: PharmacyInfo
    let medicationPharmacy: Int?
    let user: PhamracyCartUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case quantity
        case medication
        case category
        case pharmacy
        case medicationPharmacy = "medication_pharmacy"
        case user
    }
}

struct PhamracyCartMedication: Decodable {
    let id: Int?
    let name: String?  // Made optional
    let price: String
    let priceAfterDiscount: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case priceAfterDiscount = "price_after_discount"
        case image
    }
}

struct PhamracyCartCategory: Decodable {
    let id: Int
    let name: String
}

struct PharmacyInfo: Decodable {
    let id: Int
    let name: String
}

struct PhamracyCartUser: Decodable {
    let id: Int
    let name: String
}
