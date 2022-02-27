//
//  AreasController.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Vapor

protocol AreasControlling {
    /// Returns list of supported areas.
    static func getAreas(using app: Application) throws -> AreasResponse
    /// Returns area info for associated id.
    static func getAreas(id: String) -> AreasByIdResponse
}

struct AreasController: AreasControlling {
    static func getAreas(using app: Application) throws -> AreasResponse {
        guard let areas = app.supportedAreas else {
            throw Abort(.internalServerError, reason: "Failed to extract supportedAreas")
        }
        
        return .init(areas: areas)
    }
    
    static func getAreas(id: String) -> AreasByIdResponse {
        // TODO: implement :)
        return .init(id: id)
    }
}
