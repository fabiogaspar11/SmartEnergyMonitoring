//
//  APIHelper.swift
//  SmartEnergyMonitoring
//
//  Created by Daniel Soares Carreira on 28/11/2022.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidResponse
    case decodingError
    case invalidServerResponse
    case invalidURL
}

class APIHelper {
    
    enum RequestError: Error, LocalizedError {
        case invalidResponse
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
            throw RequestError.invalidResponse
        }
            
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw RequestError.decodingError
        }
        
        return(result)
    }
}
