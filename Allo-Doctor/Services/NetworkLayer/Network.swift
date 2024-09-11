//
//  Network.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 11/09/2024.
//

import Foundation

class NetworkLayer {

    // Generic POST function
    func postRequest<T: Codable>(url: URL, params: [String: Any], type: T.Type, completionHandler: @escaping (T) -> Void, errorHandler: @escaping (String) -> Void) {
           
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
           
           let task = URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
               guard let data = data, error == nil else {
                   print(error as Any)
                   errorHandler(error?.localizedDescription ?? "Error!")
                   return
               }
               
               if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                   print("status code is not 200")
                   errorHandler("Status code is not 200")
                   print(response as Any)
               }
               
               if let mappedResponse = try? JSONDecoder().decode(T.self, from: data) {
                   completionHandler(mappedResponse)
               }
           }
           
           task.resume()
       }
}
