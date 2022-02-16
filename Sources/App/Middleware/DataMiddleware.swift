//
//  DataMiddleware.swift
//  
//
//  Created by Adam Duflo on 2/16/22.
//

import Vapor

struct DataMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let daKey = Environment.get("DA_KEY") else {
            throw Abort(.internalServerError, reason: "Failed to extract data access key.")
        }
        
        guard request.headers["Data-Access-Key"].contains(daKey) else {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}
