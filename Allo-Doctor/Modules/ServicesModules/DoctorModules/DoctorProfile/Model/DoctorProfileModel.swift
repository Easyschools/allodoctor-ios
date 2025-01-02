//
//  DoctorProfileModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/11/2024.
//

import Foundation
// MARK: - DoctorResponse
struct DoctorProfileResponse: Decodable {
    let data: DoctorProfile
}

struct DoctorsResponse: Decodable {
    let data: [DoctorProfile]
}
// MARK: - Doctor
struct DoctorProfile: Decodable {
    let id: Int
    let name: String
    let titleEn: String?
    let titleAr: String?
    let title: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let description: String?
    let address: String?
    let lat: Double?
    let long: Double?
    let rate: Double?
    let waitingTime: Int?
    let price: String?
    let priceAfterDiscount: String?
    let experience: String?
    let mainImage: String?
//    let district: String?
//    let districtId: Int?
    let images: [ClinicImages]?
    let serviceSpecialtyIds: Int?
    let appointments: [DoctorAppointment]?
    let appointmentsBooking: [DoctorAppointmentBooking]?
//    let infoService: [InfoService]?
//    let speciality: [Speciality]
//    let branches: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, title, description, address, lat, long, rate, price, experience, images
        case titleEn = "title_en"
        case titleAr = "title_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case waitingTime = "waitng_time"
        case priceAfterDiscount = "price_after_discount"
        case mainImage = "main_image"
//        case district, districtId = "district_id"
        case serviceSpecialtyIds = "service_specialty_ids"
        case appointments
        case appointmentsBooking = "appointments_booking"
//        case infoService = "infoService"
    }
}

// MARK: - Appointment
struct DoctorAppointment: Decodable {
    let appointmentDayHourId: Int
    let day: Day
    let hour: [Hour]

    enum CodingKeys: String, CodingKey {
        case appointmentDayHourId = "appointment_day_hour_id"
        case day, hour
    }
}

// MARK: - Day
struct DoctorDay: Decodable {
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

// MARK: - Hour
struct DoctorHour: Decodable {
    let appointmentDayHourId: Int
    let id: Int
    let from: String
    let to: String

    enum CodingKeys: String, CodingKey {
        case appointmentDayHourId = "appointment_day_hour_id"
        case id, from, to
    }
}

// MARK: - AppointmentBooking
struct DoctorAppointmentBooking: Decodable {
    let day: Day
//    let hours: [BookingHour]
}

// MARK: - BookingHour
struct DoctorBookingHour: Decodable {
    let id: Int
    let from: String
    let to: String
}

struct ClinicImages: Decodable {
    let id: Int?
    let image: String?
}

// MARK: - InfoService
struct InfoService: Decodable {
    let id: Int?
    let name: String?
    let nameAr: String?
    let nameEn: String?
    let descriptionAr: String?
    let descriptionEn: String?
    let districtId: Int?
    let serviceIdOriginal: Int?
    let image: String?
    let isActive: Int?
    let address: String?
    let lat: Double?
    let long: Double?
    let operationServiceId: Int?
//    let branchesCount: Int
//    let branches: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, image, address, lat, long
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case districtId = "district_id"
        case serviceIdOriginal = "service_id_original"
        case isActive = "is_active"
        case operationServiceId = "operation_service_id"
//        case branchesCount = "branches_count"
    }
}

// MARK: - Speciality
struct Speciality: Decodable {
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
