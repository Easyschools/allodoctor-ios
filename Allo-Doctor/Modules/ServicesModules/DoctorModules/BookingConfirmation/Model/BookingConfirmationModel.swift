//
//  BookingConfirmationModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 09/12/2024.
//

import Foundation
struct BookingResponse: Codable {
    let data: BookingRequest?
}

// User data model
struct  BookingRequest: Codable {
    let name: String?
    let phone: String?
    let appointmentDayHourId: Int?
    let availability : Int?
    let userId:Int?
    let date : String?
    let doctorServiceSpecialtyId :Int?
    enum CodingKeys: String, CodingKey {
        case name
        case phone
        case availability
        case appointmentDayHourId = "appointment_day_hour_id"
        case doctorServiceSpecialtyId = "doctor_service_specialty_id"
        case date
        case userId = "user_id"
    }
}


