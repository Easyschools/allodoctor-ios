//
//  UnifiedHospital.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import Foundation

// MARK: - Unified Hospital List Response
struct HospitalListResponse: Decodable {
    let data: [UnifiedHospital]

    enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Unified Hospital Model
struct UnifiedHospital: Decodable {
    let id: Int
    let name: String
    let nameEn: String?
    let nameAr: String?
    let description: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let address: String?
    let image: String?
    let backgroundImage: String?
    let latitude: String?
    let longitude: String?
    let avgRating: Double?
    let reviewsCount: Int?
    let district: HospitalDistrict?
    let districtId: Int?
    let specialties: [HospitalSpecialty]?
    let services: [HospitalService]?
    let phone: String?
    let email: String?
    let workingHours: String?

    // Computed property for distance (can be calculated based on user location)
    var distance: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, description, address, image, phone, email
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case backgroundImage = "background_image"
        case latitude = "lat"
        case longitude = "long"
        case avgRating = "avg_rating"
        case reviewsCount = "reviews_count"
        case district
        case districtId = "district_id"
        case specialties
        case services
        case workingHours = "working_hours"
    }
}

// MARK: - Hospital District
struct HospitalDistrict: Decodable {
    let id: Int
    let name: String?
    let nameEn: String?
    let nameAr: String?
    let cityId: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case cityId = "city_id"
    }
}

// MARK: - Hospital Specialty (Clinics within Hospital)
struct HospitalSpecialty: Decodable, Identifiable {
    let id: Int
    let name: String
    let nameEn: String?
    let nameAr: String?
    let description: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let image: String?
    let doctorsCount: Int?
    let availableAppointments: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case doctorsCount = "doctors_count"
        case availableAppointments = "available_appointments"
    }
}

// MARK: - Hospital Service (One Day Care, Operations, etc.)
struct HospitalService: Decodable {
    let id: Int
    let serviceType: String?
    let nameEn: String?
    let nameAr: String?
    let price: String?
    let from: String?
    let to: String?

    enum CodingKeys: String, CodingKey {
        case id, price, from, to
        case serviceType = "service_type"
        case nameEn = "name_en"
        case nameAr = "name_ar"
    }
}

// MARK: - Hospital Profile Detail Response (Single Hospital)
struct HospitalProfileResponse: Decodable {
    let data: HospitalProfile

    enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Hospital Profile (Detailed)
struct HospitalProfile: Decodable {
    let id: Int
    let name: String
    let nameEn: String?
    let nameAr: String?
    let description: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let address: String?
    let image: String?
    let backgroundImage: String?
    let images: [String]?
    let latitude: String?
    let longitude: String?
    let avgRating: Double?
    let reviewsCount: Int?
    let district: HospitalDistrict?
    let phone: String?
    let email: String?
    let workingHours: String?
    let specialties: [HospitalSpecialty]
    let services: [HospitalService]?
    let medicalInsurance: [MedicalInsurance]?
    let reviews: [HospitalReview]?
    let about: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, address, image, images, phone, email, about
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case backgroundImage = "background_image"
        case latitude = "lat"
        case longitude = "long"
        case avgRating = "avg_rating"
        case reviewsCount = "reviews_count"
        case district
        case workingHours = "working_hours"
        case specialties
        case services
        case medicalInsurance = "medical_insurance"
        case reviews
    }
}

// MARK: - Medical Insurance
struct MedicalInsurance: Decodable {
    let id: Int
    let name: String?
    let nameEn: String?
    let nameAr: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case nameEn = "name_en"
        case nameAr = "name_ar"
    }
}

// MARK: - Hospital Review
struct HospitalReview: Decodable {
    let id: Int
    let userName: String?
    let userImage: String?
    let rating: Double?
    let comment: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, rating, comment
        case userName = "user_name"
        case userImage = "user_image"
        case createdAt = "created_at"
    }
}

// MARK: - Hospital Specialty Detail Response
struct HospitalSpecialtyDetailResponse: Decodable {
    let data: HospitalSpecialtyDetail

    enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Hospital Specialty Detail (with Doctors)
struct HospitalSpecialtyDetail: Decodable {
    let specialty: HospitalSpecialty
    let doctors: [SpecialtyDoctor]
    let availableServices: [SpecialtyService]?

    enum CodingKeys: String, CodingKey {
        case specialty, doctors
        case availableServices = "available_services"
    }
}

// MARK: - Specialty Doctor
struct SpecialtyDoctor: Decodable {
    let id: Int
    let name: String
    let title: String?
    let titleEn: String?
    let titleAr: String?
    let description: String?
    let mainImage: String?
    let rate: Double?
    let reviewsCount: Int?
    let price: String?
    let priceAfterDiscount: String?
    let experience: String?
    let waitingTime: String?
    let availableAppointments: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, title, description, rate, price, experience
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case mainImage = "main_image"
        case reviewsCount = "reviews_count"
        case priceAfterDiscount = "price_after_discount"
        case waitingTime = "waiting_time"
        case availableAppointments = "available_appointments"
    }
}

// MARK: - Specialty Service
struct SpecialtyService: Decodable {
    let id: Int
    let name: String?
    let nameEn: String?
    let nameAr: String?
    let price: String?
    let duration: String?

    enum CodingKeys: String, CodingKey {
        case id, name, price, duration
        case nameEn = "name_en"
        case nameAr = "name_ar"
    }
}
