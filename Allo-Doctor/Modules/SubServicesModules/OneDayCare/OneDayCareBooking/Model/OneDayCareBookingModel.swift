//
//  OneDayCareBookingModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/12/2024.
//

import Foundation


// Request Body Model
struct ConfirmOneDayRequestResponse: Codable {
    let data: ConfirmOneDayRequest?
}
struct ConfirmOneDayRequest: Codable {
    let name: String?
    let phone: String?
    let info_day_service_id: Int?
    let date: String?
}

