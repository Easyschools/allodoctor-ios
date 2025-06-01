//
//  ExternalClinicsHospitalsModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/11/2024.
//

import Foundation

struct ExternalClinicDataResponse: Decodable {
    let data: ExternalClinicData?
}

struct ExternalClinicData: Decodable {
    let id: Int?
    let nameAr: String?
    let nameEn: String?
    let serviceId: Int?
    let service: Service?
    let doctors: [ExternalClinicDoctor]?
    let infoServices: [InfoServiceWrapper]?

    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case serviceId = "service_id"
        case service
        case doctors
        case infoServices = "info_services"
    }
}



struct ExternalClinicDoctor: Decodable {
    let id: Int?
    let name: String?
    let titleEn: String?
    let titleAr: String?
    let titleTypeEn: String?
    let titleTypeAr: String?
    let title: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let description: String?
    let address: String?
    let rate: Double?
    let waitingTime: Int?
    let price: Double?
    let priceAfterDiscount: Double?
    let experience: Int?
    let mainImage: String?
    let districtId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case titleTypeEn = "title_type_en"
        case titleTypeAr = "title_type_ar"
        case title
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case description
        case address
        case rate
        case waitingTime = "waitng_time"
        case price
        case priceAfterDiscount = "price_after_discount"
        case experience
        case mainImage = "main_image"
        case districtId = "district_id"
    }
}

struct InfoServiceWrapper: Decodable {
    let infoService: InfoService?
    let clinicInfo: ExtternalClinicInfo?

    enum CodingKeys: String, CodingKey {
        case infoService = "info_service"
        case clinicInfo = "clinic_info"
    }
}



struct ExtternalClinicInfo: Decodable {
    let externalClinicServicesId: Int?
    let externalClinicNameAr: String?
    let externalClinicNameEn: String?
    let externalClinicDescriptionAr: String?
    let externalClinicDescriptionEn: String?
    let infoServiceId: Int?
    let price: String?
    let address: String?
    let image: String?
    let userId: Int?
    let districtId: Int?

    enum CodingKeys: String, CodingKey {
        case externalClinicServicesId = "external_clinic_services_id"
        case externalClinicNameAr = "external_clinic_name_ar"
        case externalClinicNameEn = "external_clinic_name_en"
        case externalClinicDescriptionAr = "external_clinic_description_ar"
        case externalClinicDescriptionEn = "external_clinic_description_en"
        case infoServiceId = "info_service_id"
        case price
        case address
        case image
        case userId = "user_id"
        case districtId = "district_id"
    }
}
