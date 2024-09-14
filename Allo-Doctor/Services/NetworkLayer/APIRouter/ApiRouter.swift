//
//  ApiRouter.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//

import Foundation
enum APIRouter {
    case registerUser(UserData)
    case fetchServices(isPaginate: Int)
    
    var url: URL {
        switch self {
        case .registerUser:
            return URL(string: "https://allodoctor-backend.developnetwork.net/api/auth/register")!
        case .fetchServices(let isPaginate):
            return URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/service/all?is_paginate=\(isPaginate)")!
        }
    }
    
    var method: String {
        switch self {
        case .registerUser:
            return "POST"
        case .fetchServices:
            return "GET"
        }
    }
    
    var body: Data? {
        switch self {
        case .registerUser(let request):
            return try? JSONEncoder().encode(request)
        case .fetchServices:
            return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .registerUser:
            return ["Content-Type": "application/json"]
        case .fetchServices:
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
