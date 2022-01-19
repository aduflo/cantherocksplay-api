//
//  HTTPRequest.swift
//  
//
//  Created by Adam Duflo on 1/18/22.
//

import Foundation

struct HTTPRequest {
    let path: String
    let queryParams: [String: String]
    
    var url: URL? {
        var urlComponents = URLComponents(string: path)
        urlComponents?.queryItems = queryParams.map { pair in
            return URLQueryItem(name: pair.key, value: pair.value)
        }
        return urlComponents?.url
    }
}
