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
    let name: String?
    let nameAr: String?
    let nameEn: String?
    let image: String?
    let totalPrice: String
    let totalQuantity: Int
    let discount: String
    let totalAfterDiscount: String
    let items: [CartItem]

    enum CodingKeys: String, CodingKey {
        case pharmacyID = "pharmacy_id"
        case name
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case image
        case totalPrice = "total_price"
        case totalQuantity = "total_quantity"
        case discount
        case totalAfterDiscount = "total_after_discount"
        case items
    }
}

struct CartItem: Decodable {
    let id: Int
    let quantity: Int
    let medication: Medication
    let category: CategoryCart
    let pharmacy: PharmacyCart
    let medicationPharmacy: MedicationPharmacies
    let user: UserCart
}

struct Medication: Decodable {
    let id: Int
    let name: String
    let image: String?
}

struct CategoryCart: Decodable {
    let id: Int
    let name: String
}

struct PharmacyCart: Decodable {
    let id: Int
    let name: String
}

struct MedicationPharmacies: Decodable {
    let id: Int
    let price: String
    let priceAfterDiscount: String?

    enum CodingKeys: String, CodingKey {
        case id
        case price
        case priceAfterDiscount = "price_after_discount"
    }
}

struct UserCart: Decodable {
    let id: Int
    let name: String
}
