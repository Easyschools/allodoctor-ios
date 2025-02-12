//
//  SharedDataManager.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/10/2024.
//
import Foundation

// Example data model (if you have a more complex JSON structure)
struct MyDataModel: Decodable {
    let id: Int
    let name: String
}

class SharedDataManager {
    static let shared = SharedDataManager()
    
    // Shared publisher for dynamic data
    @Published var sharedArray: [MyDataModel] = []
    
    // Subject to trigger network call once and share the result
    private var dataPublisher: AnyPublisher<[MyDataModel], Never>?
    
    // Method to fetch dynamic data (network call)
    func fetchData() -> AnyPublisher<[MyDataModel], Never> {
        // If the dataPublisher is already set, return it to avoid re-fetching
        if let publisher = dataPublisher {
            return publisher
        }

        // Simulate a network call and dynamically decode the JSON response
        let url = URL(string: "https://example.com/data")! // Replace with your API URL

        // Create the dataPublisher
        let publisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .map { data, _ in data }
            .decode(type: [MyDataModel].self, decoder: JSONDecoder()) // Decode dynamic data
            .replaceError(with: []) // Handle errors, returning an empty array on failure
            .share() // Share the result with multiple subscribers
            .eraseToAnyPublisher()

        // Cache the publisher so it only fetches once
        self.dataPublisher = publisher

        return publisher
    }

    private init() { }
}
