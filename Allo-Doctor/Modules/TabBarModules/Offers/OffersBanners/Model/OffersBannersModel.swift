//
//  OffersBannersModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/12/2024.
//

import Foundation

struct BannerResponse: Decodable {
    let data: [Banner]?
}

struct Banner: Decodable {
    let id: Int?
    let bannerableType: String?
    let bannerableId: Int?
    let image: String?
    let banner: Int?
    let related: Related?

    enum CodingKeys: String, CodingKey {
        case id
        case bannerableType = "bannerable_type"
        case bannerableId = "bannerable_id"
        case image
        case banner
        case related
    }
}

struct Related: Decodable {
    let id: Int?
    let name: String?
    let nameAr : String?
    let nameEn: String?
    let titleEn: String?
    let titleAr: String?
    let image : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case nameEn =  "name_en"
        case nameAr = "name_ar"
        case image = "main_image"
    }
}
