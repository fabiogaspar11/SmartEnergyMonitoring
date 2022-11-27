//
//  StaticJSONMapper.swift
//  SmartEnergyMonitoring
//
//  Created by Fábio Cordeiro Gaspar on 24/11/2022.
//

import Foundation

struct StaticJSONMapper {
    
    static func decode<T: Decodable>(response: Data, type: T.Type) throws -> T {
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: response)
        }
        catch {
            print("There is a problem decoding")
            throw MappingError.failedToDecode
        }
        
    }
    
}

extension StaticJSONMapper {
    enum MappingError: Error {
        case failedToGetContents
        case failedToDecode
    }
}
