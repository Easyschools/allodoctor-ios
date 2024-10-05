//
//  ClinicProfileModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import Foundation
// Model for the entire response
struct ClinicResponseData:Decodable {
    let data: ClinicService
}

struct ClinicService:Decodable {
    let id: Int
    let name: String
//    let name_ar: String
//    let name_en: String
//    let description: String
//    let description_ar: String
//    let description_en: String
//    let image: String
    let info_service: [ClinicInfo]
}

// Model for Clinic Info
struct ClinicInfo :Decodable{
    let id: Int
    let name: String
    let name_en: String
    let description_en: String
    let image: String
  
  
}

struct ClinicResponse: Decodable {
    let data: Clinic
}

struct Clinic: Decodable {
    let id: Int
    let name: String
    let nameAr: String
    let nameEn: String
    let descriptionAr: String
    let descriptionEn: String
    let districtId: Int
    let serviceIdOriginal: Int
    let district: clinicDistrict
    let image: String
    let isActive: Int
    let address: String?
    let lat: Double?
    let long: Double?
    let doctorsCount: Int
    let specialtiesCount: Int
    let branchesCount: Int
    let doctors: [ClinicDoctor]
    let specialties: [ClinicSpecialty]
    let branches: [Branch]

    enum CodingKeys: String, CodingKey {
        case id, name, image, address, lat, long, branches
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case districtId = "district_id"
        case serviceIdOriginal = "service_id_original"
        case district
        case isActive = "is_active"
        case doctorsCount = "doctors_count"
        case specialtiesCount = "specialties_count"
        case branchesCount = "branches_count"
        case doctors, specialties
    }
}

struct clinicDistrict: Decodable {
    let id: Int
    let name: String
}



struct ClinicDoctor: Decodable {
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
    let waitingTime: Int?
    let price: String
    let priceAfterDiscount: String
    let experience: String
    let mainImage: String
    let serviceSpecialtyIds: Int
    let appointments: [ClinicAppointment]
    let appointmentsBooking: [String]
    let services: [ClinicDoctorService]
    let branches: [Branch]

    enum CodingKeys: String, CodingKey {
        case id, name, title, description, address, lat, long, rate, price, experience, appointments, services, branches
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case waitingTime = "waitng_time"
        case priceAfterDiscount = "price_after_discount"
        case mainImage = "main_image"
        case serviceSpecialtyIds = "service_specialty_ids"
        case appointmentsBooking = "appointments_booking"
    }
}

struct ClinicAppointment: Decodable {
    let appointmentDayHourId: Int
    let day: ClinicDay
    let hour: [ClinicHour]

    enum CodingKeys: String, CodingKey {
        case appointmentDayHourId = "appointment_day_hour_id"
        case day, hour
    }
}

struct ClinicDay: Decodable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let name: String
    let available: Int

    enum CodingKeys: String, CodingKey {
        case id, name, available
        case nameEn = "name_en"
        case nameAr = "name_ar"
    }
}

struct ClinicHour: Decodable {
    let appointmentDayHourId: Int
    let id: Int
    let from: String
    let to: String

    enum CodingKeys: String, CodingKey {
        case appointmentDayHourId = "appointment_day_hour_id"
        case id, from, to
    }
}

struct ClinicDoctorService: Decodable {
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

struct ClinicSpecialty: Decodable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let name: String
    let descriptionEn: String
    let descriptionAr: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
    }
}

struct Branch: Decodable {
    // Add properties if needed
}


