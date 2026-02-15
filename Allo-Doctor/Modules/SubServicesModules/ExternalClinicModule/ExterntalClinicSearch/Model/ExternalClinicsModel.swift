//
//  ExternalClinicsModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import Foundation
struct ExternalClinicResponse: Decodable {
    let data: [ExternalClinicsData]?
    let links: Links?
    let meta: Meta?
}

// MARK: - Clinic Data
struct ExternalClinicsData: Decodable {
    let id: Int?
    let nameAr: String?
    let nameEn: String?
    let serviceID: Int?
    let infoServices: [ExternalClinicInfoServiceWrapper]?

    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case serviceID = "service_id"
        case infoServices = "info_services"
    }
}

struct ExternalClinicInfoServiceWrapper: Decodable {
    let clinicInfo: ExternalClinicInfo?

    enum CodingKeys: String, CodingKey {
        case clinicInfo = "clinic_info"
    }
}

struct ExternalClinicInfo: Decodable {
    let externalClinicServicesId: Int?
    let infoServiceId: Int?

    enum CodingKeys: String, CodingKey {
        case externalClinicServicesId = "external_clinic_services_id"
        case infoServiceId = "info_service_id"
    }
}
