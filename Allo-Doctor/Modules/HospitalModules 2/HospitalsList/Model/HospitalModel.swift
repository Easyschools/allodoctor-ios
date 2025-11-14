//
//  HospitalModel.swift
//  Allo-Doctor
//
//  Created by Assistant on 14/11/2025.
//

import Foundation

// MARK: - Hospital Response
struct HospitalResponse: Codable {
    let data: [HospitalInfoService]
    let links: HospitalLinks?
    let meta: HospitalMeta?
}

// MARK: - Hospital Info Service
struct HospitalInfoService: Codable {
    let id: Int
    let name: String?
    let nameAr: String?
    let nameEn: String?
    let descriptionAr: String?
    let descriptionEn: String?
    let description: String?
    let avgRating: Double?
    let reviewsCount: Int?
    let districtId: HospitalDistrict?
    let serviceIdOriginal: Int?
    let email: String?
    let phoneNumber: String?
    let district: HospitalDistrict?
    let serviceId: HospitalServiceInfo?
    let image: String?
    let backgroundImage: String?
    let infoServiceNo: String?
    let isActive: Int?
    let address: String?
    let lat: String?
    let long: String?
    let doctorsCount: Int?
    let specialtiesCount: Int?
    let branchesCount: Int?
    let doctors: [Doctor]?
    let specialties: [Specialty]
    let branches: [HospitalBranch]?
    let medicalInsurance: [MedicalInsurance]?
    let oneDayServices: [OneDayService]?

    enum CodingKeys: String, CodingKey {
        case id, name, description, email, image, address, lat, long, district
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case avgRating = "avg_rating"
        case reviewsCount = "reviews_count"
        case districtId = "district_id"
        case serviceIdOriginal = "service_id_original"
        case phoneNumber = "phone_number"
        case serviceId = "service_id"
        case backgroundImage = "background_image"
        case infoServiceNo = "info_service_no"
        case isActive = "is_active"
        case doctorsCount = "doctors_count"
        case specialtiesCount = "specialties_count"
        case branchesCount = "branches_count"
        case doctors, specialties, branches
        case medicalInsurance = "medical_insurance"
        case oneDayServices = "One Day Services"
    }
}

// MARK: - Hospital District
struct HospitalDistrict: Codable {
    let id: Int
    let cityId: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case cityId = "city_id"
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}

// MARK: - Hospital Service Info
struct HospitalServiceInfo: Codable {
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
    let parentId: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, order, image
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case parentId = "parent_id"
    }
}

// MARK: - Specialty
//struct Specialty: Codable {
//    let id: Int
//    let nameEn: String?
//    let nameAr: String?
//    let name: String?
//    let descriptionEn: String?
//    let descriptionAr: String?
//    let description: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description
//        case nameEn = "name_en"
//        case nameAr = "name_ar"
//        case descriptionEn = "description_en"
//        case descriptionAr = "description_ar"
//    }
//}

// MARK: - Hospital Branch
struct HospitalBranch: Codable {
    let id: Int
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let address: String?

    enum CodingKeys: String, CodingKey {
        case id, name, address
        case nameEn = "name_en"
        case nameAr = "name_ar"
    }
}

// MARK: - Medical Insurance
//struct MedicalInsurance: Codable {
//    let id: Int?
//    let nameAr: String?
//    let nameEn: String?
//    let name: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case nameAr = "name_ar"
//        case nameEn = "name_en"
//    }
//}

// MARK: - One Day Service
//struct OneDayService: Codable {
//    // Define properties based on your API response
//}

// MARK: - Doctor (Basic)
//struct Doctor: Codable {
//    let id: Int?
//    let nameEn: String?
//    let nameAr: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nameEn = "name_en"
//        case nameAr = "name_ar"
//    }
//}

// MARK: - Pagination Links
struct HospitalLinks: Codable {
    let first: String?
    let last: String?
    let prev: String?
    let next: String?
}

// MARK: - Pagination Meta
struct HospitalMeta: Codable {
    let currentPage: Int?
    let from: Int?
    let lastPage: Int?
    let path: String?
    let perPage: Int?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case path, total
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case perPage = "per_page"
        case to
    }
}
