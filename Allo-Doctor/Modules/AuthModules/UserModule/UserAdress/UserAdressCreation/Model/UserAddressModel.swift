//
//  UserAddressModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/12/2024.
//

import Foundation

extension Notification.Name {
    static let newAddressCreated = Notification.Name("newAddressCreated")
}

    struct UserAddressBody: Encodable {
        let lat: String?
        let long: String?
        let floor: String?
        let address: String?
        let appartment_number: Int?
    }
   struct UserAddressResponseData: Codable {
    let data: AddressData?
   }

struct AddressData: Codable {
    let id: Int?
    let address: String?
   

    enum CodingKeys: String, CodingKey {
        case id, address
    }
}
