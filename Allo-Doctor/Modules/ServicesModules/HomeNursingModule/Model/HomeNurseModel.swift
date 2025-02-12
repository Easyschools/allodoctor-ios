//
//  HomeNurseModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/12/2024.
//

import Foundation
struct BookingHomeNursingBodyResponse: Codable {
    let data:BookingHomeNursingBody?
    let statusCode: Int?
    let error: String?
    let message:String?
}
struct BookingHomeNursingBody:Codable {
    let name:String?
    let age:String?
    let phone:String?
    let address:String?
    let district_id:Int?
    let notes:String?
}
