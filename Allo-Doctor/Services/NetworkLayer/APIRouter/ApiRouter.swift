//
//  ApiRouter.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//
import Foundation

enum APIRouter {
    case registerUser(UserData)
    
    var url: URL {
        switch self {
        case .registerUser:
            return URL(string: "https://allodoctor-backend.developnetwork.net/api/auth/register")!
        }
    }
    
    var method: String {
        switch self {
        case .registerUser:
            return "POST"
        }
    }
    
    var body: Data? {
        switch self {
        case .registerUser(let request):
            return try? JSONEncoder().encode(request)
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .registerUser:
            return ["Content-Type": "application/json"]
        }
    }
    
    func makeRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
