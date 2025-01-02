//
//  labAndScansBookingModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/10/2024.
//
import Foundation

// MARK: - Main Data Model
struct LabsAndScanBookingResponse: Decodable {
    let data: LabsAndScanBookingData
}

// MARK: - Data
struct LabsAndScanBookingRequest:Codable{
    let appointment_lab_id: String
    let availability: String
    let userID: String
    let name: String
    let phone: String
    let location: String
    let types: String

    enum CodingKeys: String, CodingKey {
        case appointment_lab_id
        case availability
        case userID = "user_id"
        case name
        case phone
        case location
        case types
    }
}
struct LabsAndScanBookingData: Decodable {
    let id: Int
    let appointments: BookingAppointment
    let availability: String
    let userID: Int
    let user: LabsAndScanUser?
    let name: String
    let phone: String
    let location: String
    let relativeOption: String
    let symptoms: String?
    let voiceNote: String?
    let viewTestPrerequisites: String?
    let prescriptions: [String]?
    let documents: [String]?
    let types: [TestType]

    enum CodingKeys: String, CodingKey {
        case id
        case appointments
        case availability
        case userID = "user_id"
        case user
        case name
        case phone
        case location
        case relativeOption = "relative_option"
        case symptoms
        case voiceNote = "voice_note"
        case viewTestPrerequisites = "view_test_prerequisites"
        case prescriptions
        case documents
        case types
    }
}

// MARK: - Appointment
struct BookingAppointment: Decodable {
    let id: Int
    let appointmentType: String
    let appointmentHour: AppointmentHour
    let appointmentDay: AppointmentDay
    let appointmentData: String?

    enum CodingKeys: String, CodingKey {
        case id
        case appointmentType = "appointment_type"
        case appointmentHour = "appointment_hour"
        case appointmentDay = "appointment_day"
        case appointmentData = "appointment_data"
    }
}

// MARK: - AppointmentHour
struct AppointmentHour: Decodable {
    let id: Int
    let from: String
    let to: String
}

// MARK: - AppointmentDay
struct AppointmentDay: Decodable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let name: String
    let available: Int

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case available
    }
}

// MARK: - User
struct LabsAndScanUser: Decodable {
    let id: Int
    let name: String
}

// MARK: - TestType
struct TestType: Codable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let descriptionEn: String
    let descriptionAr: String
    let instructionEn: String
    let instructionAr: String
    let price: String

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case instructionEn = "instruction_en"
        case instructionAr = "instruction_ar"
        case price
    }
}

