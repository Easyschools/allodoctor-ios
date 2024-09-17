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
    case fetchSubServices(isPaginate: Int)
    var url: URL {
        switch self {
        case .registerUser:
            return URL(string: "https://allodoctor-backend.developnetwork.net/api/auth/register")!
        case .fetchServices(let isPaginate):
            return URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/service/all?is_paginate=\(isPaginate)")!
        case .fetchSubServices(let isPaginate):
            return URL(string: "https://allodoctor-backend.developnetwork.net/api/admin/sub-service/all?is_paginate=\(isPaginate)")!
        
        }
    }
    
    var method: String {
        switch self {
        case .registerUser:
            return "POST"
        case .fetchServices,.fetchSubServices:
            return "GET"
        }
    }
    
    var body: Data? {
        switch self {
        case .registerUser(let request):
            return try? JSONEncoder().encode(request)
        case .fetchServices,.fetchSubServices:
            return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .registerUser:
            return ["Content-Type": "application/json"]
        case .fetchServices,.fetchSubServices:
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
