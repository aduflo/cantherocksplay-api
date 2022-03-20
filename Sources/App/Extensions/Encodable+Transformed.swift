//
//  Encodable+Transformed.swift
//  
//
//  Created by Adam Duflo on 3/15/22.
//

import Foundation

// TODO: determine if needed.. if not, remove + remove test file
public extension Encodable {
    // TODO: determine if even needed... probs not
    /// Transforms `self` into a JSON-encoded `Data` representation.
    func toJSONData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    // TODO: determine if even needed... probs not
    /// Transforms `self` into a JSON-formatted `String` representation.
    func toJSONString() -> String? {
        guard let data = try? toJSONData() else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
