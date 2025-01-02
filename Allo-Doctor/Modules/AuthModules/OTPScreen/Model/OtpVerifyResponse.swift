//
//  OtpVerifyResponse.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 28/09/2024.
//

import Foundation
struct OtpVerifyResponse:Codable{
    let otp:String 
    let phone : String
}
struct OtpMessageResponse: Decodable {
    let message: String
 
}
