//
//  UploadPrescripotionModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/12/2024.
//

import Foundation
struct UploadPrescriptionBodyResponse: Codable {
    let confirmOrderBody: ConfirmUploadPrescriptionBody
}
struct ConfirmUploadPrescriptionBody: Codable {
    let address_id: Int
    let pharmacy_id: Int
    let address_user_id : Int
    let payment_type:String
}
