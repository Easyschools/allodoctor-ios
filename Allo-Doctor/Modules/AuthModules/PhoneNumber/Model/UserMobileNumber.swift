//
//  userMobileNumber.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 27/09/2024.
//

import Foundation
struct PhoneNumberRequest: Codable {
    let phone: String
}
struct responseMessage:Decodable {
let message:String
let data :String
}
