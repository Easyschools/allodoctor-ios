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
    let payment_type: String
    let address_id: Int
    let pharmacy_id: Int
    let address_user_id : Int
    let order_status_id:Int
    let reminder_type:String
}

struct OrderResponseData:Codable{
    let order: OrderResponse
    let payment_url : String?
}
struct OrderResponse: Codable {
       let userId: Int?
        let createdBy: Int?
    let id:Int?
   

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case createdBy = "created_by"
             case id
        }
}
struct OrderStatusResponse: Codable {
    let data: OrderDataCheck
   
}
struct OrderDataCheck: Codable {
    let orderStatus: OrderStatusCheck
    enum CodingKeys: String, CodingKey {
  
        case orderStatus = "order_status"
    
    }
}
struct OrderStatusCheck: Codable {
    let id: Int
    let name: String
    let nameAr: String
    let nameEn: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}
