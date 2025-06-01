//
//  APIClient.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//

import Foundation
import Alamofire

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
                    },
                    to: url,
                    headers: headers
                )
                .validate()
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
 



    // MARK: - Main Function
    func postData<T: Decodable, U: Encodable>(
        to url: URL,
        body: U,
        as type: T.Type,
        imageKey: String? = nil,
        imageData: Data? = nil,
        fileName: String? = nil
    ) -> AnyPublisher<T, Error> {
        // Generate a unique boundary for multipart form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Add Authorization header if token exists
        if let authorizationHeader = AuthManager.shared.getAuthorizationHeader() {
            print("Authorization Header: \(authorizationHeader)")
            request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        }

        if let imageData = imageData, let imageKey = imageKey, let fileName = fileName {
            // Set Content-Type to multipart/form-data
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            // Construct multipart form-data body
            var data = Data()

            // Add JSON data as a form field
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Optional: Makes JSON more readable in debug
            if let jsonData = try? encoder.encode(body) {
                data.append(createFormField(named: "data",
                                            value: String(data: jsonData, encoding: .utf8) ?? "",
                                            boundary: boundary))
            }

            // Add the image file
            data.append(createFileData(fieldName: imageKey,
                                       fileName: fileName,
                                       mimeType: "image/png", // Adjust MIME type as needed
                                       fileData: imageData,
                                       boundary: boundary))

            // Add the closing boundary
            data.append("--\(boundary)--\r\n".data(using: .utf8)!)

            // Assign the body to the request
            request.httpBody = data
        } else {
            // For non-image requests, send JSON body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(body)
        }

        // Make the network request
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                // Log the raw response for debugging
                if let responseString = String(data: result.data, encoding: .utf8) {
                    print("Server Response: \(responseString)")
                }

                // Ensure the status code is within the successful range
                guard let httpResponse = result.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
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
