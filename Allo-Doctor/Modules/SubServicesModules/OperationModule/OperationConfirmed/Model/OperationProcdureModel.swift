//
//  OperationProcdureModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/12/2024.
//

import Foundation


struct OperationProcedureResponse: Decodable {
    let data: OperationProcedure
}

struct OperationProcedure: Decodable {
    let id: Int
    let operationServiceId: Int
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let descriptionEn: String?
    let descriptionAr: String?
    let estimatedDurationEn: String?
    let estimatedDurationAr: String?
    let expectedHospitalStayEn: String?
    let expectedHospitalStayAr: String?
    let operation: OperationProcdureName?
    
    enum CodingKeys: String, CodingKey {
        case id
        case operationServiceId = "operation_service_id"
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case estimatedDurationEn = "estimated_duration_en"
        case estimatedDurationAr = "estimated_duration_ar"
        case expectedHospitalStayEn = "expected_hospital_stay_en"
        case expectedHospitalStayAr = "expected_hospital_stay_ar"
        case operation

    }
}


struct OperationProcdureName: Decodable {
    let id: Int
    let nameEn: String?
    let nameAr: String?
    let name: String?
    let serviceId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case name
        case serviceId = "service_id"
    }
}
