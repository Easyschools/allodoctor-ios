//
//  Favourites.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 29/12/2024.
//

import Foundation
struct FavouritesModel:Codable{
 let favoritable_entity:String
  let favoritable_id:Int
}
struct FavouritesModelResponse:Codable{
    let message: String?
}

