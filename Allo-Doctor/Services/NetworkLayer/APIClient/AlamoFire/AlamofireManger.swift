//
//  AlamofireManger.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/12/2024.
//
import Alamofire
import UIKit

enum NetworkErrorr: Error {
    case invalidURL
    case serverError(message: String)
    case unknownError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    /// Uploads an image to the given URL.
    /// - Parameters:
    ///   - url: API endpoint.
    ///   - image: UIImage to upload.
    ///   - parameterName: Name of the parameter expected by the server for the image.
    ///   - parameters: Additional parameters to send with the request.
    ///   - completion: Completion handler returning success or error.
    func uploadImage(
        to url: String,
        image: UIImage,
        parameterName: String,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<Any, Error>) -> Void
    ) {
        guard let requestURL = URL(string: url) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NetworkError.invalidData))
            return
        }

        var headers: HTTPHeaders = [:]
        if let authHeader = AuthManager.shared.getAuthorizationHeader() {
            headers["Authorization"] = authHeader
        }

        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: parameterName, fileName: "image.jpg", mimeType: "image/jpeg")
                parameters?.forEach { key, value in
                    if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: requestURL,
            headers: headers
        )
        .uploadProgress { progress in
            print("Upload progress: \(progress.fractionCompleted)")
        }
        .response { response in
            if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
                print("Raw Response: \(responseString)")
            }

            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}


enum NetworkError: Error {
    case unauthorized
    case invalidData
    case networkError(String)
    case invalidResponse
    case invalidImage
    case serverError(String)
}

final class NetworkService {
    static let shared = NetworkService()
    private let baseURL: String
    
    private init() {
        self.baseURL = "https://allodoctor-backend.developnetwork.net/api" // Replace with your actual base URL
    }
    
    // MARK: - Post Data Function
    func postData<T: Encodable>(
            endpoint: String,
            data: T,
            completion: @escaping (Result<Data, NetworkError>) -> Void
        ) {
            // Create mutable headers
            var headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            
            // Add authorization header if token exists
            if let token = AuthManager.shared.getAuthorizationHeader() {
                headers["Authorization"] = token
            }
            
            let url = "\(baseURL)/\(endpoint)"
            
            AF.request(
                url,
                method: .post,
                parameters: data,
                encoder: JSONParameterEncoder.default,
                headers: headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure:
                    self.handleError(response: response, completion: completion)
                }
            }
        }
       // MARK: - Upload Single Image Function
    func uploadSingleImage(
        endpoint: String,
        image: UIImage,
        imageParameterName: String = "photo_of_medical_card", // Add this parameter with default value
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        guard let token = AuthManager.shared.getAuthorizationHeader() else {
            completion(.failure(.unauthorized))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(.invalidImage))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": token,
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        let url = "\(baseURL)/\(endpoint)"
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // Add image data with the specified parameter name
                multipartFormData.append(
                    imageData,
                    withName: imageParameterName, // Use the parameter name here
                    fileName: "image.jpg",
                    mimeType: "image/jpeg"
                )
                
                // Add additional parameters if provided
                parameters?.forEach { key, value in
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: url,
            headers: headers
        )
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                self.handleError(response: response, completion: completion)
            }
        }
    }
    
    // MARK: - Handle Errors
    private func handleError(
        response: AFDataResponse<Data>,
        completion: (Result<Data, NetworkError>) -> Void
    ) {
        guard let data = response.data else {
            completion(.failure(.networkError("No response data")))
            return
        }
        
        // Attempt to decode Laravel-like error response
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let message = json["message"] as? String {
                completion(.failure(.serverError(message)))
            } else {
                completion(.failure(.invalidResponse))
            }
        } catch {
            completion(.failure(.networkError(error.localizedDescription)))
        }
    }
}
// MARK: - NetworkService Extension for Multiple Image Upload
extension NetworkService {
    func uploadMultipleImages(
        endpoint: String,
        images: [UIImage],
        imageParameterName: String = "images",
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        guard let token = AuthManager.shared.getAuthorizationHeader() else {
            completion(.failure(.unauthorized))
            return
        }
        
        guard !images.isEmpty else {
            completion(.failure(.invalidData))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": token,
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        let url = "\(baseURL)/\(endpoint)"
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // Add multiple images as array - images[0], images[1], images[2]
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(
                            imageData,
                            withName: "\(imageParameterName)[\(index)]", // Format: images[0], images[1], images[2]
                            fileName: "doctorCall.jpg", // Use consistent filename
                            mimeType: "image/jpeg"
                        )
                    }
                }
                
                // Add additional parameters if provided
                parameters?.forEach { key, value in
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: url,
            headers: headers
        )
        .uploadProgress { progress in
            print("Multiple Upload Progress: \(progress.fractionCompleted)")
        }
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                self.handleError(response: response, completion: completion)
            }
        }
    }
}
