//
//  labAppointment.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 25/11/2024.
//

import Foundation

// MARK: - Main Response Model
struct LapAppointmentResponse: Decodable {
    let data: LapAppointmentsData?
    let message: String?
}

// MARK: - Data Container
struct LapAppointmentsData: Decodable {
    let headers: [String: String]?
    let original: [LapAppointment]?
    let exception: String?
}

// MARK: - LapAppointment
struct LapAppointment: Decodable {
    let id: Int?
    let appointmentDay: LabAppointmentDay?
    let appointmentHour: [LabAppointmentHour]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case appointmentDay = "appointment_day"
        case appointmentHour = "appointment_hour"
    }
}

// MARK: - AppointmentDay
struct LabAppointmentDay: Decodable {
    let id: Int?
    let nameAr: String?
    let nameEn: String?
    let available: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case available
    }
}

// MARK: - AppointmentHour
struct LabAppointmentHour: Decodable {
    let id: Int?
    let from: String?
    let to: String?
    let availability: String?
    let hasBooking: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case from
        case to
        case availability
        case hasBooking = "has_booking"
    }
}
