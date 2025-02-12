//
//  DoctorModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import Foundation

//struct DoctorsResponse: Decodable {
//    let data: [DoctorData]
//
//}
struct DoctorResponse: Decodable {
    let data: DoctorData

}
struct DoctorData: Decodable {
    let id: Int
    let name: String
    let titleEn: String
    let titleAr: String
    let title: String?
    let descriptionEn: String
    let descriptionAr: String
    let description: String
    let address: String
    let lat: Double?
    let long: Double?
    let rate: Double?
    let waitngTime: String?
    let price: String
    let priceAfterDiscount: String
    let experience: String
    let mainImage: String?
    let images: [DoctorImage]
    let serviceSpecialtyIds: Int
    let appointments: [Appointment]?
    let services: [DoctorService]
    let subServices:String
    let branches: [String]
    let avgRating : Double
    let reviewsCount: Int
    let doctorServiceSpecialtyIds:[DoctorServiceSpecialty]?
    enum CodingKeys: String, CodingKey {
        case id, name, title, address, lat, long, rate, price, experience, images, appointments, services, branches,subServices
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case description
        case waitngTime = "waitng_time"
        case priceAfterDiscount = "price_after_discount"
        case mainImage = "main_image"
        case avgRating = "avg_rating"
        case reviewsCount = "reviews_count"
        case serviceSpecialtyIds = "service_specialty_ids"
        case doctorServiceSpecialtyIds = "doctor_service_specialty_ids"
    }
}
struct DoctorServiceSpecialty: Decodable {
    let id: Int?
    let infoService: InfoService?

    enum CodingKeys: String, CodingKey {
        case id
        case infoService = "info_service"
    }
}
struct DoctorImage: Decodable {
    let id: Int
    let image: String
}

struct Appointment: Decodable {
    let id: Int
    let day: Day
    let hour: Hour
}

struct Day: Decodable {
    let id: Int
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let available: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, available
        case nameEn = "name_en"
        case nameAr = "name_ar"
    }
}

struct Hour: Decodable {
    let id: Int
    let from: String
    let to: String
}

struct DoctorService: Decodable {
    let id: Int
    let nameAr: String?
    let nameEn: String?
    let name: String?
    let slug: String?
    let descriptionAr: String?
    let description: String?
    let descriptionEn: String?
    let order: Int?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, order, image
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
    }
}

