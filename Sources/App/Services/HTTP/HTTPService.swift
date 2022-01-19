//
//  HTTPService.swift
//  
//
//  Created by Adam Duflo on 1/18/22.
//

import Foundation

protocol HTTPServicing {
    typealias GETHandler = (Result<Data, HTTPError>) -> Void
    func get(_ request: HTTPRequest, completion: @escaping GETHandler)
}

struct HTTPService: HTTPServicing {

    func get(_ request: HTTPRequest, completion: @escaping GETHandler) {
        guard let url = request.url else {
            completion(.failure(.urlMissing))
            return
        }
        
        // TODO: determine if dataTask cancellation should be supported
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            if let error = error {
                completion(.failure(.error(error)))
                return
            }
            
            guard urlResponse != nil else {
                completion(.failure(.urlResponseMissing))
                return
            }
            
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(.urlResponseWrongType))
                return
            }
            
            guard (200..<300) ~= httpUrlResponse.statusCode else {
                completion(.failure(.statusCodeNotSuccess(httpUrlResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataMissing))
                return
            }
            
            completion(.success(data))
        }
        dataTask.resume()
    }
}
