//
//  IntensiveCareModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/11/2024.
//

import Foundation

struct IntensiveCareBodyResponse: Codable {
    let confirmOrderBody: IntensiveCareBody?

}
struct IntensiveCareBody:Codable {
    let name: String
    let phone: String
    let district_id:Int
    let birthdate : String
    let type : String
    let accept_terms:Int
}
