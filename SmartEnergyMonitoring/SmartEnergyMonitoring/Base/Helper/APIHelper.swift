//
//  APIHelper.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 28/11/2022.
//

import Foundation

class APIHelper : ObservableObject {
    
    static func request<T: Decodable>(url: String, parameters: [String: String], method: String, type: T.Type) -> T {
        var semaphore = DispatchSemaphore (value: 0)

        let postData = try? JSONEncoder().encode(parameters)

        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = method
        request.httpBody = postData
        
        var result: T!

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            
          guard error == nil else { fatalError() }
            
          guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
              semaphore.signal()
              return
          }
            
          do {
            result = try JSONDecoder().decode(T.self, from: data)
          }
          catch {
            fatalError()
          }
            
          semaphore.signal()
        }
        
        semaphore.wait()
        
        return result
    }
}
