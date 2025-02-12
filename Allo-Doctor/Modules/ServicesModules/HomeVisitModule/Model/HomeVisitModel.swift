//
//  HomeVisitModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/11/2024.
//

import Foundation
struct BookingHomeBodyResponse: Codable {
    let confirmOrderBody: BookingHomeBody?

}
struct BookingHomeBody:Codable {
    let name: String
    let phone: String
    let address: String
    let district_id:Int
    let accept_terms:Int
    let speciality_id : Int
}
