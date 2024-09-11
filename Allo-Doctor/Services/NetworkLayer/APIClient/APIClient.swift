//
//  APIClient.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//
import Foundation
import Combine
class APIClient {
    func fetchData<T: Decodable>(from url: URL, as type: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
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

    func postData<T: Decodable, U: Encodable>(to url: URL, body: U, as type: T.Type) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                // Check the HTTP response status code
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                // Print response headers and raw response data for debugging
                let rawData = String(data: result.data, encoding: .utf8)
//                print("Response Headers: \(httpResponse.allHeaderFields)")
                print("Raw Response Data: \(rawData ?? "nil")")

                // Handle non-200 status codes
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("errrooooorrrrrrrrrrrr")
                    throw URLError(.badServerResponse)
                }
                
                // Check if the response data is HTML
                if rawData?.contains("<html") == true {
                    print("errrooooorrrrrrrrrrrr")
                    
                    throw URLError(.badServerResponse)
                }

                // Return the data if all checks pass
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }


    func putData<T: Decodable, U: Encodable>(to url: URL, body: U, as type: T.Type) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.dataTaskPublisher(for: request)
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
}
