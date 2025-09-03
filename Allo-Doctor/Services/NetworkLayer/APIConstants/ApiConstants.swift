//
//  ApiConstants.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import Foundation

final class APIConstants {
//    static var basedURL: String = "https://Backend.allo-doctor.com/api"
    static var basedURL: String = "https://backend.allo-doctor.com/api"


}

enum HTTPHeaderField: String {
    case authentication = "/auth/register"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case authorization = "Authorization"
    case acceptLanguage = "Accept-Language"
}

enum ContentType: String {
    case json = "application/json"
}

enum APIError: Error {
    case network(String)         // Network-related errors (e.g., no internet, timeout)
    case decoding(String)        // Decoding errors when the response doesn't match the expected
    case server(String)
    case unknown
   
}
