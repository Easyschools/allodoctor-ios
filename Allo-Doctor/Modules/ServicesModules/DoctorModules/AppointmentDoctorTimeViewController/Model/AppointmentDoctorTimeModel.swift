//
//  AppointmentDoctorTimeModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/10/2024.
//

import Foundation

// Main response model
struct DoctorAppointmentAvailableResponse: Decodable {
    let appointments: [DoctorAppointmentAvailable]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        appointments = try container.decode([DoctorAppointmentAvailable]?.self)
    }
}

// Individual appointment model
struct DoctorAppointmentAvailable: Decodable {
    let id: Int?
    let appointmentDay: DoctorAppointmentDay?
    let appointmentHour: [DoctorAppointmentHour]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case appointmentDay = "appointment_day"
        case appointmentHour = "appointment_hour"
    }
}

// Day model
struct DoctorAppointmentDay: Decodable {
    let id: Int?
    let nameAr: String?
    let nameEn: String?
    let available: Int?
    let deletedAt: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case available
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// Hour model
struct DoctorAppointmentHour: Decodable {
    let appointmentDayHoursId: Int?
    let id: Int?
    let from: String?
    let to: String?
    let appointmentDayId: Int?
    let deletedAt: String?
    let createdAt: String?
    let updatedAt: String?
    let availability: String?
    let hasBooking: Bool?
    
    enum CodingKeys: String, CodingKey {
        case appointmentDayHoursId = "appointment_day_hours_id"
        case id
        case from
        case to
        case appointmentDayId = "appointment_day_id"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case availability
        case hasBooking = "hasbooking"
    
    }
}
