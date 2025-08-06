//
//  ProfileFavouritesModel.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/12/2024.
//

import Foundation

// MARK: - Favourites
struct Favourites: Codable {
    let message: String?
    var data: [FavouriteData]?
}

// MARK: - FavouriteData
struct FavouriteData: Codable {
    let id: Int
    let favoritableType: String
    let favoritableID: Int
    let favoritable: Favoritable?
    let favoritableName: String

    enum CodingKeys: String, CodingKey {
        case id
        case favoritableType = "favoritable_type"
        case favoritableID = "favoritable_id"
        case favoritable
        case favoritableName = "favoritable_name"
    }
}

// MARK: - Favoritable
struct Favoritable: Codable {
    let id: Int
    let mainImage: String?
    let nameEn: String?
    let nameAr: String?
    let titleAr: String?
    let titleEn: String?

 

    enum CodingKeys: String, CodingKey {
        case id
        case mainImage = "main_image"
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case titleAr = "title_ar"
        case titleEn = "title_en"
      
    }
}
