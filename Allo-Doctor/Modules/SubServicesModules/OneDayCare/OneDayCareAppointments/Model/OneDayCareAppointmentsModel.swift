//
//  OneDayCareAppointmentsModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 27/12/2024.
//

import Foundation
struct Response<T: Decodable>: Decodable {
    let data: T?
    let message: String?
    let errors: [String]?
    let statusCode: Int?
    
    enum CodingKeys: String, CodingKey {
        case data, message, errors
        case statusCode = "status_code"
    }
}

struct OneDayCareAppointmentsModel: Decodable {
    let data: AppointmentData
    
    struct AppointmentData: Decodable {
        let id: Int?
        let price: String?
        let from: String?
        let to: String?
        let infoService: InfoService?
        let dayService: DayService?
        var days: [DayAvailability]?
        
        enum CodingKeys: String, CodingKey {
            case id, price, from, to
            case infoService = "info_service"
            case dayService = "day_service"
            case days
        }
    }
    
    struct InfoService: Decodable {
        let id: Int?
        let name: String?
        let nameAr: String?
        let nameEn: String?
        let descriptionAr: String?
        let descriptionEn: String?
        let avgRating: Double?
        let reviewsCount: Int?
        let serviceIdOriginal: Int?
        let image: String?
        let backgroundImage: String?
        let infoServiceNo: String?
        let isActive: Int?
        let address: String?
        let lat: Double?
        let long: Double?
        
        enum CodingKeys: String, CodingKey {
            case id, name, image, address, lat, long
            case nameAr = "name_ar"
            case nameEn = "name_en"
            case descriptionAr = "description_ar"
            case descriptionEn = "description_en"
            case avgRating = "avg_rating"
            case reviewsCount = "reviews_count"
            case serviceIdOriginal = "service_id_original"
            case backgroundImage = "background_image"
            case infoServiceNo = "info_service_no"
            case isActive = "is_active"
        }
    }
    
    struct DayService: Decodable {
        let id: Int?
        let nameEn: String?
        let nameAr: String?
        let descriptionEn: String?
        let descriptionAr: String?
        let image: String?
        let backgroundImage: String?
        let address: String?
        let lat: Double?
        let long: Double?
        
        enum CodingKeys: String, CodingKey {
            case id, image, address, lat, long
            case nameEn = "name_en"
            case nameAr = "name_ar"
            case descriptionEn = "description_en"
            case descriptionAr = "description_ar"
            case backgroundImage = "background_image"
        }
    }
    
    struct DayAvailability: Decodable {
        let id: Int?
        let availability: Int?
        let day: Day?
    }
    
    struct Day: Decodable {
        let id: Int?
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
}
