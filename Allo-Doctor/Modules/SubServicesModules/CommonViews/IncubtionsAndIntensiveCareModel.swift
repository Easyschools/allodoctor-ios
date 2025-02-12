//
//  IncubtionsAndIntensiveCareModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/11/2024.
//

import Foundation

struct IncubtionsAndIntensiveCareModel: Codable {
    let name: String
    let district_id:Int?
    let accept_terms : Int?
    let phone: String?
    let birthdate: String?

}

struct IncubtionsAndIntensiveCareModelResponse: Codable {
    let statusCode: Int?
    let errorMessage: String?
    let data: IncubtionsAndIntensiveCareModel?
}
