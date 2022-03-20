//
//  AreasMiddleware.swift
//  
//
//  Created by Adam Duflo on 2/17/22.
//

import Vapor

struct AreasMiddleware: AsyncMiddleware {
    // TODO: is CA_KEY really needed? if someone listens to traffic on their device, they can just sniff this out. it's like a security camera w/o any power; a visual threat
    // TODO: if keep this, should also use it for healthcheck endpoint
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
