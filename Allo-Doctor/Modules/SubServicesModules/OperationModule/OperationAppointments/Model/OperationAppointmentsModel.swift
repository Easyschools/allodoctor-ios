//
//  OperationAppointmentsModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 19/11/2024.
//

import Foundation

// MARK: - Main Data Model
struct HospitalScheduleResponse: Decodable {
    let data: [HospitalSchedule]?
}

// MARK: - Schedule Model
struct HospitalSchedule: Decodable {
    let id: Int?
    let operationServiceID: Int?
    let day: Day?
    let from: String?
    let to: String?
    let availability: Int?

    // Coding keys to map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case id
        case operationServiceID = "operation_service_id"
        case day
        case from
        case to
        case availability
    }
}

