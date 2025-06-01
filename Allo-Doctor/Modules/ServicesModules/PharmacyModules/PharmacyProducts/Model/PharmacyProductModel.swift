//
//  PharmacyProductModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/10/2024.
//

struct ProductResponse: Decodable {
    let data: [Product]?
}

struct Product: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let typeId: Int?
    let mainImage: String?
    let price: String?
    let deletedAt: String?
    let createdAt: String?
    let updatedAt: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let priceAfterDiscount: String?
    let type: MedicationType?
    let medicationPharmacies: [MedicationPharmacy]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case typeId = "type_id"
        case mainImage = "main_image"
        case price
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case priceAfterDiscount = "price_after_discount"
        case type
        case medicationPharmacies = "medication_pharmacies"
    }
}

struct MedicationType: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let deletedAt: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct MedicationPharmacy: Decodable {
    let id: Int?
    let medicationId: Int?
    let pharmacyId: Int?
    let categoryId: Int?
    let quantity: Int?
    let availability: Int?
    let price: String?
    let discountPercentage: String?
    let priceAfterDiscount: String?
    let deletedAt: String?
    let createdAt: String?
    let updatedAt: String?
//    let pharmacy: Pharmacy?
    let category: Category?
    
    enum CodingKeys: String, CodingKey {
        case id
        case medicationId = "medication_id"
        case pharmacyId = "pharmacy_id"
        case categoryId = "category_id"
        case quantity
        case availability
        case price
        case discountPercentage = "discount_percentage"
        case priceAfterDiscount = "price_after_discount"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
//        case pharmacy
        case category
    }
}


//struct MedicationType: Decodable {
//    let id: Int
//    let nameEn: String
//    let nameAr: String
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nameEn = "name_en"
//        case nameAr = "name_ar"
//    }
//}
