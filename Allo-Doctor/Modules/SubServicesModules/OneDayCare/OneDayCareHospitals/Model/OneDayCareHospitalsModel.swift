//
//  OneDayCareHospitalsModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/12/2024.
//

import Foundation


struct OneDayCarHosptalsData: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let image: String?
    let backgroundImage: String?
    let address: String?

    
    // Coding keys to match JSON keys with property names
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case image
        case backgroundImage = "background_image"
        case address
      
    }
}

struct OneDayCarHosptalsResponse: Decodable {
    let data: [OneDayCarHosptalsData]?
}
