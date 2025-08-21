//
//  APIClient.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//

import Foundation
import Alamofire
import UIKit

protocol PaginatedResponse: Decodable {
    associatedtype Item: Decodable
    var data: [Item]? { get }
    var nextPageURL: URL? { get }
}
struct ErrorResponse: Decodable {
   let message: String
   let errors: [String: [String]]
}
class APIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
 
    
 func fetchData<T: Decodable>(from url: URL, as type: T.Type) -> AnyPublisher<T, Error> {
        // Create request with auth headers
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add Bearer token if available
        if let authHeader = AuthManager.shared.getAuthorizationHeader() {
            request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    func fetchAllPages<T: PaginatedResponse>(from url: URL, as type: T.Type) -> AnyPublisher<[T.Item], Error> {
        /// Recursive function to fetch each page and accumulate items.
        func fetchPage(_ url: URL, accumulatedItems: [T.Item]) -> AnyPublisher<[T.Item], Error> {
            fetchData(from: url, as: type)
                .flatMap { response -> AnyPublisher<[T.Item], Error> in
                    // Combine the current page's items with previously accumulated items.
                    let updatedItems = accumulatedItems + (response.data ?? [])
                    
                    // Check if there is a next page.
                    if let nextPageURL = response.nextPageURL {
                        // Fetch the next page.
                        return fetchPage(nextPageURL, accumulatedItems: updatedItems)
                    } else {
                        return Just(updatedItems)
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }
                }
                .eraseToAnyPublisher()
        }
        
        // Start fetching from the initial URL with an empty accumulator.
        return fetchPage(url, accumulatedItems: [])
    }

    
 
    func postDataImage<T: Decodable>(
            to url: String,
            body: Encodable,
            as responseType: T.Type,
            imageKey: String,
            imageData: Data,
            fileName: String
        ) -> AnyPublisher<T, Error> {
            return Future<T, Error> { promise in
                guard let encodedBody = try? JSONEncoder().encode(body),
                      let bodyDict = try? JSONSerialization.jsonObject(with: encodedBody) as? [String: Any] else {
                    promise(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode request body."])))
                    return
                }
                
                let headers: HTTPHeaders = [
                    "Authorization": AuthManager.shared.getAuthorizationHeader() ?? "",
                    "Content-Type": "multipart/form-data"
                ]
                
                AF.upload(
                    multipartFormData: { formData in
                        // Add image
                        formData.append(imageData, withName: imageKey, fileName: fileName, mimeType: "image/jpeg")
                        
                        // Add other parameters
                        bodyDict.forEach { key, value in
                            if let valueString = value as? String, let data = valueString.data(using: .utf8) {
                                formData.append(data, withName: key)
                            }
                        }
                        print("the body of upload image: \n")
                        dump(formData)
                    },
                    to: url,
                    headers: headers
                )
                //.validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let result):
                        promise(.success(result))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
 


    func sendImageAttachment(
        image: UIImage,
        url: URL,
        receiverId: Int,
        supportType: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Invalid image", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add receiver_id
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"receiver_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(receiverId)\r\n".data(using: .utf8)!)

        // Add support_type
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"support_type\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(supportType)\r\n".data(using: .utf8)!)

        // Add image file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }

            let responseString = String(data: data, encoding: .utf8) ?? ""
            completion(.success(responseString))

        }.resume()
    }



     //MARK: - Main Function

    // MARK: - Multipart helpers
    private func createFormFieldPostData(named name: String, value: String, boundary: String) -> Data {
        var fieldData = Data()
        fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        fieldData.append("\(value)\r\n".data(using: .utf8)!)
        return fieldData
    }

    private func createFileDataPostData(fieldName: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
        return data
    }

    // MARK: - Modified postData
    func postData<T: Decodable, U: Encodable>(
        to url: URL,
        body: U,
        as type: T.Type,
        imageKey: String? = nil,
        imageData: Data? = nil,
        fileName: String? = nil
    ) -> AnyPublisher<T, Error> {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Authorization header if exists
        if let authorizationHeader = AuthManager.shared.getAuthorizationHeader() {
            print("Authorization Header: \(authorizationHeader)")
            request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        }

        // Multipart (image) branch
        if let imageData = imageData, let imageKey = imageKey, let fileName = fileName {
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var data = Data()

            // Convert Encodable body -> JSON -> [String: Any] and append each key as its own form field
            let encoder = JSONEncoder()
            // Use snake_case if your models require it:
            // encoder.keyEncodingStrategy = .convertToSnakeCase
            if let jsonData = try? encoder.encode(body),
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
               let dict = jsonObject as? [String: Any] {

                // Append fields in deterministic order (optional)
                for (key, value) in dict {
                    let valueString: String

                    // If nested array/dict -> serialize to compact JSON string
                    if JSONSerialization.isValidJSONObject(value) {
                        if let nestedData = try? JSONSerialization.data(withJSONObject: value, options: []),
                           let nestedString = String(data: nestedData, encoding: .utf8) {
                            valueString = nestedString
                        } else {
                            valueString = "\(value)"
                        }
                    } else {
                        // Primitive types (String, Number, Bool) -> string representation
                        valueString = "\(value)"
                    }

                    // Append the form field. Key names must match server expected parameter names.
                    data.append(createFormFieldPostData(named: key, value: valueString, boundary: boundary))
                }
            } else {
                // Fallback: send entire JSON as single "data" field (not ideal)
                if let jsonData = try? encoder.encode(body),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    data.append(createFormFieldPostData(named: "data", value: jsonString, boundary: boundary))
                }
            }

            // Append file
            // Try to detect mime type from file extension if possible (simple heuristic)
            let mimeType: String
            if fileName.lowercased().hasSuffix(".png") {
                mimeType = "image/png"
            } else if fileName.lowercased().hasSuffix(".jpg") || fileName.lowercased().hasSuffix(".jpeg") {
                mimeType = "image/jpeg"
            } else {
                mimeType = "application/octet-stream"
            }

            data.append(createFileDataPostData(fieldName: imageKey, fileName: fileName, mimeType: mimeType, fileData: imageData, boundary: boundary))

            // Closing boundary
            data.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = data

        } else {
            // JSON branch
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            // encoder.keyEncodingStrategy = .convertToSnakeCase // uncomment if server expects snake_case keys
            request.httpBody = try? encoder.encode(body)
        }

        print("request send postData :\n ")
        dump(request)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                if let responseString = String(data: result.data, encoding: .utf8) {
                    print("Server Response: \(responseString)")
                }
                guard let httpResponse = result.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }



    // MARK: - Async/await version of postData
    func postDataAsync<T: Decodable, U: Encodable>(
        to url: URL,
        body: U,
        as type: T.Type,
        imageKey: String? = nil,
        imageData: Data? = nil,
        fileName: String? = nil
    ) async throws -> T {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Authorization header if exists
        if let authorizationHeader = AuthManager.shared.getAuthorizationHeader() {
            request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        }

        // Multipart (image) branch
        if let imageData = imageData, let imageKey = imageKey, let fileName = fileName {
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var data = Data()

            // Convert Encodable body -> JSON -> [String: Any] and append each key as its own form field
            let encoder = JSONEncoder()
            // encoder.keyEncodingStrategy = .convertToSnakeCase // enable if your server expects snake_case
            if let jsonData = try? encoder.encode(body),
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
               let dict = jsonObject as? [String: Any] {

                // Append fields (deterministic order isn't required but can help debugging)
                for (key, value) in dict {
                    let valueString: String
                    if JSONSerialization.isValidJSONObject(value) {
                        if let nestedData = try? JSONSerialization.data(withJSONObject: value, options: []),
                           let nestedString = String(data: nestedData, encoding: .utf8) {
                            valueString = nestedString
                        } else {
                            valueString = "\(value)"
                        }
                    } else {
                        valueString = "\(value)"
                    }
                    data.append(createFormFieldPostData(named: key, value: valueString, boundary: boundary))
                }
            } else {
                // Fallback: send entire JSON as single "data" field
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(body)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    data.append(createFormFieldPostData(named: "data", value: jsonString, boundary: boundary))
                }
            }

            // Append file
            let mimeType: String
            if fileName.lowercased().hasSuffix(".png") {
                mimeType = "image/png"
            } else if fileName.lowercased().hasSuffix(".jpg") || fileName.lowercased().hasSuffix(".jpeg") {
                mimeType = "image/jpeg"
            } else {
                mimeType = "application/octet-stream"
            }

            data.append(createFileDataPostData(fieldName: imageKey, fileName: fileName, mimeType: mimeType, fileData: imageData, boundary: boundary))

            // Closing boundary
            data.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = data

        } else {
            // JSON branch
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            // encoder.keyEncodingStrategy = .convertToSnakeCase // uncomment if server wants snake_case
            request.httpBody = try encoder.encode(body)
        }

        // Debug print request (you can remove in production)
        print("request send postDataAsync :\n ")
        dump(request)

        // Use async URLSession API — respects Task cancellation
        let (responseData, response) = try await URLSession.shared.data(for: request)

        // Optionally log response string (debug)
        if let responseString = String(data: responseData, encoding: .utf8) {
            print("Server Response: \(responseString)")
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Decode result
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: responseData)
        return decoded
    }


    func deleteData<T: Decodable>(from url: URL, as type: T.Type) -> AnyPublisher<T, Error> {
        // Create a URLRequest with DELETE method
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add Bearer token if available
        if let authHeader = AuthManager.shared.getAuthorizationHeader() {
            request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                // Log the response for debugging
                if let responseString = String(data: result.data, encoding: .utf8) {
                    print("Server Response: \(responseString)")
                }
                
                // Check HTTP status code
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.init(rawValue: httpResponse.statusCode))
                }
                
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                // Map URLSession and decoding errors to a unified error type
                if let decodingError = error as? DecodingError {
                    print("Decoding Error: \(decodingError)")
                } else if let urlError = error as? URLError {
                    print("URL Error: \(urlError)")
                } else {
                    print("Unknown Error: \(error)")
                }
                return error
            }
            .eraseToAnyPublisher()
    }
    // Helper function to create a form field in multipart form-data
    private func createFormField(named name: String, value: String, boundary: String) -> Data {
        var fieldData = Data()
        fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n".data(using: .utf8)!)
        fieldData.append("\r\n".data(using: .utf8)!)
        fieldData.append("\(value)\r\n".data(using: .utf8)!)
        return fieldData
    }

    // Helper function to create a file field in multipart form-data
    private func createFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
        return data
    }
    enum NetworkError: LocalizedError {
        case serverError(message: String, errors: [String: [String]])
        case invalidResponse
        case unauthorized
        case forbidden
        case notFound
        case noInternetConnection
        case timeout
        case connectionLost
        case networkError(underlying: Error)
        case unknown(statusCode: Int)
        
        var errorDescription: String? {
            switch self {
            case .serverError(let message, _):
                return message
            case .invalidResponse:
                return "The server response was invalid."
            case .unauthorized:
                return "You are not authorized to access this resource."
            case .forbidden:
                return "Access to this resource is forbidden."
            case .notFound:
                return "The requested resource was not found."
            case .noInternetConnection:
                return "No internet connection. Please check your network settings."
            case .timeout:
                return "The request timed out. Please try again."
            case .connectionLost:
                return "The network connection was lost."
            case .networkError(let underlying):
                return "A network error occurred: \(underlying.localizedDescription)"
            case .unknown(let statusCode):
                return "An unknown error occurred (status code: \(statusCode))."
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .serverError(_, let errors):
                return errors.flatMap { "\($0.key): \($0.value.joined(separator: ", "))" }.joined(separator: "\n")
            case .noInternetConnection:
                return "Please reconnect to the internet and try again."
            case .timeout:
                return "You can try resending the request."
            case .connectionLost:
                return "Ensure your connection is stable before retrying."
            default:
                return nil
            }
        }
    }


    func putData<T: Decodable, U: Encodable>(to url: URL, body: U, as type: T.Type) -> AnyPublisher<T, Error> {var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add Bearer token if available
        if let authHeader = AuthManager.shared.getAuthorizationHeader() {
            request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    private func createMultipartBody(
        boundary: String,
        parameters: [String: Any]?,
        imageKey: String,
        imageData: Data,
        fileName: String
    ) -> Data {
        var body = Data()
        
        // Add parameters
        parameters?.forEach { key, value in
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(imageKey)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!) // Adjust content type if needed
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }

}

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "Invalid JSON", code: 0, userInfo: nil)
        }
        return dictionary
    }
}
