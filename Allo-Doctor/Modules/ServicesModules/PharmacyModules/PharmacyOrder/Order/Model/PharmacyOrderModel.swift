//
//  PharmacyOrderModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import Foundation
struct ConfirmOrderBodyResponse: Codable {
    let confirmOrderBody: ConfirmOrderBody
    let statusCode: Int
}
struct ConfirmOrderBody: Codable {
    let payment_type_id: Int
    let address_id: Int
    let pharmacy_id: Int
    let address_user_id : Int
}
