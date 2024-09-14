//
//  APIClientProtocol.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 14/09/2024.
//

import Foundation
import Combine
protocol APIClientProtocol {
    func fetchData<T: Decodable>(from url: URL, as type: T.Type) -> AnyPublisher<T, Error>
}
