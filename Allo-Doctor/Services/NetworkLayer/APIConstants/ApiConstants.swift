//
//  ApiConstants.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import Foundation

final class APIConstants {
    static var basedURL: String = "https://allodoctor-backend.developnetwork.net/api"
}

enum HTTPHeaderField: String {
    case authentication = "/auth/register"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case authorization = "Authorization"
    case acceptLanguage = "Accept-Language"
    case userAgent = "User-Agent"
}

enum ContentType: String {
    case json = "application/json"
    case xwwwformurlencoded = "application/x-www-form-urlencoded"
}

//import Foundation
//
//enum APIEndpoint {
//    case authentication
//    case profile
//    case specialties
//    // Add more endpoints as needed
//}
//
//final class APIConstants {
//    static let shared = APIConstants()
//    
//    private init() {}
//    
//    private let basedURL: String = "https://allodoctor-backend.developnetwork.net/api"
//    
//    func buildUrl(_ endpoint: APIEndpoint) -> String {
//        switch endpoint {
//        case .authentication:
//            return basedURL + "/auth/register"
//        case .profile:
//            return basedURL + "/profile"
//        case .specialties:
//            return basedURL + "/specialties"
//        // Add more cases as needed
//        }
//    }
//}
//
//enum HTTPHeaderField: String {
//    case contentType = "Content-Type"
//    case acceptType = "Accept"
//    case acceptEncoding = "Accept-Encoding"
//    case authorization = "Authorization"
//    case acceptLanguage = "Accept-Language"
//    case userAgent = "User-Agent"
//}
//
//enum ContentType: String {
//    case json = "application/json"
//    case xwwwformurlencoded = "application/x-www-form-urlencoded"
//}
