//
//  APIHelper.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 28/11/2022.
//

import Foundation

class APIHelper {
    
    enum APIError: LocalizedError {
        case invalidRequestError(String)
        case transportError(Error)
        case decodingError
    }
    
    static func request<T: Decodable>(url: String, headers: [String: String]?, parameters: [String: String]?, method: String, type: T.Type) async throws -> T {

        var request = URLRequest(url: URL(string: url)!)
        
        // Headers
        (headers ?? [:]).forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        request.httpMethod = method
        
        let postData = try? JSONEncoder().encode(parameters)
        request.httpBody = postData
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            
            throw APIError.invalidRequestError("Invalid data!")
        }
            
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw APIError.decodingError
        }
        
        return(result)
    }
}
