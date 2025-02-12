import Foundation

// MARK: - OneDayCareHospitalsResponse
struct OneDayCareHospitalsResponse: Decodable {
    let data: OneDayCareHospitals?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Data
struct OneDayCareHospitals: Decodable {
    let id: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?
    let descriptionAr: String?
    let descriptionEn: String?
    let avgRating: Double?
    let reviewsCount: Int?
    let districtId: DistrictId?
    let image: String?
    let backgroundImage: String?
    let address: String?
    let oneDayServices: [OneDayService]?

    enum CodingKeys: String, CodingKey {
        case id, name, nameAr = "name_ar", nameEn = "name_en"
        case descriptionAr = "description_ar", descriptionEn = "description_en"
        case avgRating = "avg_rating", reviewsCount = "reviews_count"
        case districtId = "district_id"
        case  image, backgroundImage = "background_image"
        case address
        case oneDayServices = "One Day Services"
    }
}

// MARK: - DistrictId
struct DistrictId: Decodable {
    let id: Int?
    let cityId: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?

    enum CodingKeys: String, CodingKey {
        case id, cityId = "city_id", name, nameAr = "name_ar", nameEn = "name_en"
    }
}




// MARK: - ExternalClinic
struct ExternalClinic: Decodable {
    let id: Int?
    let nameAr: String?
    let nameEn: String?
    let serviceId: Int?

    enum CodingKeys: String, CodingKey {
        case id, nameAr = "name_ar", nameEn = "name_en", serviceId = "service_id"
    }
}

// MARK: - ExternalClinicServiceId
struct ExternalClinicServiceId: Decodable {
    let id: Int?
    let nameAr: String?
    let nameEn: String?

    enum CodingKeys: String, CodingKey {
        case id, nameAr = "name_ar", nameEn = "name_en"
    }
}



// MARK: - OneDayService
struct OneDayService: Decodable {
    let id: Int?
    let price: String?
    let from: String?
    let to: String?
    let dayService: DayService?

    enum CodingKeys: String, CodingKey {
        case id, price, from, to, dayService = "day_service"
    }
}

// MARK: - InfoService

// MARK: - DayService
struct DayService: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let image: String?
    let backgroundImage: String?
    let address: String?
    let lat: String?
    let long: String?

    enum CodingKeys: String, CodingKey {
        case id, nameEn = "name_en", nameAr = "name_ar"
        case descriptionEn = "description_en", descriptionAr = "description_ar"
        case image, backgroundImage = "background_image", address, lat, long
    }
}
