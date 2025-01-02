//
//  AppointmentDoctorTimeModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/10/2024.
//

import Foundation

// MARK: - DoctorAppointment
struct DoctorAppointmentAvailable: Decodable {
    var id: Int?
    var appointmentDay: AppointmentDay?
    var appointmentHour: [AppointmentHour]?
    
    // MARK: - AppointmentDay
    struct AppointmentDay: Decodable {
        var id: Int?
        var nameAr: String?
        var nameEn: String?
        var available: Int?
        var deletedAt: String?
        var createdAt: String?
        var updatedAt: String?
        
        private enum CodingKeys: String, CodingKey {
            case id
            case nameAr = "name_ar"
            case nameEn = "name_en"
            case available
            case deletedAt = "deleted_at"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
    
    // MARK: - AppointmentHour
    struct AppointmentHour: Decodable {
        var appointmentDayHoursId: Int?
        var id: Int?
        var from: String?
        var to: String?
        var appointmentDayId: Int?
        var deletedAt: String?
        var createdAt: String?
        var updatedAt: String?
        var availability: String?
        var hasBooking: Bool?
        
        private enum CodingKeys: String, CodingKey {
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
}

// MARK: - DoctorAppointmentsResponse
struct DoctorAppointmentsResponse: Decodable {
    var data: [DoctorAppointmentAvailable]?
  
}
