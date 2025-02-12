//
//  OperationBookingModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/12/2024.
//

import Foundation

// Request Body Model
struct ConfirmOperationRequestResponse: Codable {
    let data: ConfirmOperationRequest?
}
struct ConfirmOperationRequest: Codable {
    let user_name: String?
    let phone: String?
    let operation_service_id: Int?
    let operation_date: String?
}

// Error Response Model
struct ErrorResponses: Decodable {
    let message: String
    let errors: [String: [String]]
}

// Success Response Model
struct ConfirmOperationResponse: Decodable {
   
}
