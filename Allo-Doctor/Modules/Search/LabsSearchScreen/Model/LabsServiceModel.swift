//
//  LabsServiceModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/09/2024.
//

import Foundation

// MARK: - ServiceResponse
struct LabsServiceResponse: Decodable {
    let data: LabsServiceData
}

// MARK: - Main Data Model
struct LabsServiceData: Decodable {
    let id: Int
    let nameEn: String
    let nameAr: String
    let name: String
    let titleEn: String
    let titleAr: String
    let title: String
    let descriptionEn: String
    let descriptionAr: String
    let description: String
    let to: String
    let from: String
    let address: String
    let latitude: Double?
    let longitude: Double?
    let experience: String
    let service: Service
    let city: LabCity
    let district: District
    let mainImage: String?
    let images: [String]
    let reviews: [String]
    let appointments: [String]
}



struct LabCity: Decodable {
    let id: Int
    let name: String
}

//// MARK: - District
//struct District: Decodable {
//    let id: Int
//    let name: String
//}
