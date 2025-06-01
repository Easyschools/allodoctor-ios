//
//  OperationHospitalsModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/11/2024.
//

import Foundation
struct OperationDataResponse: Decodable {
    let data: OperationData?
}

struct OperationData: Decodable {
    let id: Int?
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let serviceID: Int?
//    let service: Service?
    let infoServices: [OperationInfoServiceWrapper]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case serviceID = "service_id"
//        case service
        case infoServices = "info_services"
    }
    
}
struct OperationInfoServiceWrapper: Decodable {
    let operationServiceID: Int?
    let price: String?
    let infoService: InfoService?
    
    enum CodingKeys: String, CodingKey {
        case operationServiceID = "operation_service_id"
        case price
        case infoService = "info_service"
    }
}



