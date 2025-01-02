//
//  PharmacyProductModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/10/2024.
//

struct ProductResponse: Decodable {
    let data: [Product]
}

struct Product: Decodable {
    let id: Int?
    let pharmacy: PharmacyMedication?
    let category: Category?
    let availability: Int?
    let quantity: Int?
    let medication: MedicationPharmacy?
}
struct PharmacyMedication: Decodable {
    let id: Int
    let nameEn: String?
    let nameAr: String?
    let titleEn: String?
    let titleAr: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let distance: Double?
    let address: String
    let cityId: Int?
    let districtId: Int?
    let latitude: String?
    let longitude: String?
    let to: String?
    let from: String?
    let pickup: Int?
    let delivery: Int?
    let phone: String?
    let url: String?
    let experience: String?
    let mainImage: String?
    let backgroundImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case distance
        case address
        case cityId = "city_id"
        case districtId = "district_id"
        case latitude
        case longitude
        case to
        case from
        case pickup
        case delivery
        case phone
        case url
        case experience
        case mainImage = "main_image"
        case backgroundImage = "background_image"
    }
}

struct MedicationPharmacy: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let descriptionEn: String?
    let descriptionAr: String?
//    let typeId:
//    let type: MedicationType
    let price: String?
    let priceAfterDiscount: String?
    let mainImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
//        case typeId = "type_id"
//        case type
        case price
        case priceAfterDiscount = "price_after_discount"
        case mainImage = "main_image"
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
