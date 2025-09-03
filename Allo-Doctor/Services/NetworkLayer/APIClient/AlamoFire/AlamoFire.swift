//
//  AlamoFire.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/12/2024.
//

import Foundation
import Alamofire
import UIKit

// MARK: - Network Error
enum NetworkErrors: Error {
    case unauthorized
    case invalidImage
    case serverError(String)
    case networkError(String)
    case invalidResponse
    case invalidData
    
    var isRetryable: Bool {
        switch self {
        case .networkError, .invalidResponse:
            return true
        case .unauthorized, .invalidImage, .serverError, .invalidData:
            return false
        }
    }
}

struct ImageUploadModel {
    let data: Data
    let name: String
    let type: String
}

class NetworkManagerAlamofire {
    static let shared = NetworkManagerAlamofire()
    private init() {}
    
    private let baseURL = "https://Backend.allo-doctor.com/api"
    
    // MARK: - Single Image Upload
    func uploadImage<T: Decodable, P: Encodable>(
        endpoint: String,
        imgType: String,
        imgData: Data,
        imageName: String,
        imageKey: String,
        additionalParams: P,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let url = "\(baseURL)\(endpoint)"
        
        var updatedHeaders = headers ?? HTTPHeaders()
        if let token = AuthManager.shared.getAuthorizationHeader() {
            updatedHeaders.add(name: "Authorization", value: token)
        }
        updatedHeaders.add(name: "Content-Type", value: "multipart/form-data")
        
        // Serialize Encodable parameters into a dictionary
        guard let paramsData = try? JSONEncoder().encode(additionalParams),
              let paramsDict = try? JSONSerialization.jsonObject(with: paramsData, options: []) as? [String: Any] else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])))
            return
        }
        
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in paramsDict {
                if let valueString = "\(value)".data(using: .utf8) {
                    multiPart.append(valueString, withName: key)
                }
            }
            
            multiPart.append(
                imgData,
                withName: imageKey,
                fileName: imageName,
                mimeType: "image/\(imgType)"
            )
        }, to: url, headers: updatedHeaders).responseDecodable(of: responseType) { response in
            switch response.result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Multiple Images Upload
    func uploadImages<T: Decodable, P: Encodable>(
               endpoint: String,
               images: [ImageUploadModel],
               imageKey: String,
               additionalParams: P,
               headers: HTTPHeaders? = nil,
               responseType: T.Type,
               completion: @escaping (Result<T, Error>) -> Void
           ) {
               let url = "\(baseURL)\(endpoint)"
               
               var updatedHeaders = headers ?? HTTPHeaders()
               if let token = AuthManager.shared.getAuthorizationHeader() {
                   updatedHeaders.add(name: "Authorization", value: token)
               }
               updatedHeaders.add(name: "Content-Type", value: "multipart/form-data")
               updatedHeaders.add(name: "Accept", value: "application/json")
               
               guard let paramsData = try? JSONEncoder().encode(additionalParams),
                     let paramsDict = try? JSONSerialization.jsonObject(with: paramsData, options: []) as? [String: Any] else {
                   completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])))
                   return
               }
               
               AF.upload(multipartFormData: { multiPart in
                   for (key, value) in paramsDict {
                       if let arrayValue = value as? [Any] {
                           // Use dot notation for array elements instead of bracket notation
                           for (index, element) in arrayValue.enumerated() {
                               if let elementData = "\(element)".data(using: .utf8) {
                                   multiPart.append(elementData, withName: "\(key).\(index)")
                               }
                           }
                       } else if let valueString = "\(value)".data(using: .utf8) {
                           multiPart.append(valueString, withName: key)
                       }
                   }
                   
                   // Use dot notation for image fields to match server expectations
                   for (index, image) in images.enumerated() {
                       multiPart.append(
                           image.data,
                           withName: "\(imageKey).\(index)",  // Changed from [\(index)] to .\(index)
                           fileName: image.name,
                           mimeType: "image/\(image.type)"
                       )
                   }
               }, to: url, headers: updatedHeaders)
               .validate()
               .responseData { response in
                   switch response.result {
                   case .success(let data):
                       do {
                           // Print raw response for debugging
                           if let rawResponse = String(data: data, encoding: .utf8) {
                               print("Raw server response:", rawResponse)
                           }
                           
                           let decoder = JSONDecoder()
                           let decodedData = try decoder.decode(responseType, from: data)
                           completion(.success(decodedData))
                       } catch {
                           // If decoding fails, create a more detailed error
                           let errorMessage: String
                           if let rawResponse = String(data: data, encoding: .utf8) {
                               errorMessage = "Decoding failed. Server response: \(rawResponse)"
                           } else {
                               errorMessage = "Decoding failed and couldn't read server response"
                           }
                           
                           completion(.failure(NSError(
                               domain: "",
                               code: 0,
                               userInfo: [NSLocalizedDescriptionKey: errorMessage]
                           )))
                       }
                   case .failure(let error):
                       // Handle error response
                       if let data = response.data,
                          let rawResponse = String(data: data, encoding: .utf8) {
                           print("Error response from server:", rawResponse)
                           completion(.failure(NSError(
                               domain: "",
                               code: error._code,
                               userInfo: [NSLocalizedDescriptionKey: "Server error: \(rawResponse)"]
                           )))
                       } else {
                           completion(.failure(error))
                       }
                   }
               }
           }
}
