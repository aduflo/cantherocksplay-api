//
//  AreasMiddleware.swift
//  
//
//  Created by Adam Duflo on 2/17/22.
//

import Vapor

struct AreasMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let caKey = Environment.get("CA_KEY") else {
            throw Abort(.internalServerError, reason: "Failed to extract client access key.")
        }
        
        guard request.headers["Access-Key"].contains(caKey) else {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}
