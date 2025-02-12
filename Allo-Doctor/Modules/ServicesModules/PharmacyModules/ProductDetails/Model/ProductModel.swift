//
//  ProductModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/10/2024.
//

import Foundation
struct AddToCartResponse: Codable {
    let addProductToCart: AddProductToCart?
}

struct AddProductToCart: Codable {
    let pharmacy_id: String
    let category_id: String
    let medication_id: String
    let quantity: String
}
