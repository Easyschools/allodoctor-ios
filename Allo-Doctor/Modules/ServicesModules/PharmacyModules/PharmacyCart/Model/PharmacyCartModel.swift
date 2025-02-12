//
//  PharmacyCartModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/10/2024.
//

import Foundation

struct PharmacyCartResponse: Decodable {
    let data: [PharmacyCartData]?
    var message:String?
}

struct PharmacyCartData: Decodable {
    let id :Int?
    let pharmacyId: Int?
    let name: String?
    let nameAr : String?
    let nameEn :String?
    let image: String?
    var totalPrice: String?
    var totalQuantity: Int
    let discount: String?
    let totalAfterDiscount: String?
    let deliveryFee:String?
    var items: [PharmacyCartItem]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case pharmacyId = "pharmacy_id"
        case name
        case image
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case deliveryFee = "delivery_fee"
        case totalPrice = "total_price"
        case totalQuantity = "total_quantity"
        case discount
        case totalAfterDiscount = "total_after_discount"
        case items
    }
}

struct PharmacyCartItem: Decodable {
    let id: Int?
    var quantity: Int
    let medication: PharmacyCartMedication?
    let category: PharmacyCartCategory?
    let pharmacy: PharmacyInfo?
    let medicationPharmacy: PharmacyMedicationPharmacy?
    let user: PharmacyCartUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case quantity
        case medication
        case category
        case pharmacy
        case medicationPharmacy = "medicationPharmacy"
        case user
    }
}

struct PharmacyCartMedication: Decodable {
    let id: Int?
    let name: String?
    let image: String?
    let nameAr :String?
    let nameEn :String?
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}

struct PharmacyCartCategory: Decodable {
    let id: Int?
    let name: String?
}

struct PharmacyInfo: Decodable {
    let id: Int?
    let name: String?
}

struct PharmacyMedicationPharmacy: Decodable {
    let id: Int?
    let price: String?
    let priceAfterDiscount: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case price
        case priceAfterDiscount = "price_after_discount"
    }
}

struct PharmacyCartUser: Decodable {
    let id: Int?
    let name: String?
}
